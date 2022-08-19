<?php namespace Jacopo\Authentication\Models;
/**
 * Class User
 *
 * @author jacopo beschi jacopo@jacopobeschi.com
 */
use Cartalyst\Sentry\Users\Eloquent\User as CartaUser;
use Jacopo\Library\Traits\OverrideConnectionTrait;
use Cartalyst\Sentry\Users\UserExistsException;
use Cartalyst\Sentry\Users\LoginRequiredException;
use App,DB;

class User extends CartaUser
{
    use OverrideConnectionTrait;

    protected $fillable = ["email", "password", "permissions", "activated", "activation_code", "activated_at", "last_login", "protected", "banned", "email_address"];

    protected $guarded = ["id"];

    /**
     * Validates the user and throws
     * Exception if fails.
     *
     * @override
     * @return bool
     * @throws \Cartalyst\Sentry\Users\UserExistsException
     */
    public function validate()
    {
        if ( ! $login = $this->{static::$loginAttribute})
        {
            throw new LoginRequiredException("A login is required for a user, none given.");
        }

        // Check if the user already exists
        $query = $this->newQuery();
        $persistedUser = $query->where($this->getLoginName(), '=', $login)->first();

        if ($persistedUser and $persistedUser->getId() != $this->getId())
        {
            throw new UserExistsException("A user already exists with login [$login], logins must be unique for users.");
        }

        return true;
    }

    public function user_profile()
    {
        return $this->hasMany('Jacopo\Authentication\Models\UserProfile');
    }

    static public function getCurrentUser() {
        $auth = app::make('Jacopo\Authentication\Interfaces\AuthenticateInterface');        
        $logged_user = $auth->getLoggedUser();
        return $logged_user;
    }

    static public function accessAll() {
        // return true;##hv added for testing
        $logged_user = User::getCurrentUser();
        if ($logged_user != null)
            return $logged_user->hasPermission("_khanlab");
        return false;
    }
    
    static public function isSuperAdmin() {
        $logged_user = User::getCurrentUser();
        if ($logged_user != null)
            return $logged_user->hasPermission("_superadmin");
        return false;       
    }

    static public function isProjectManager() {
        $logged_user = User::getCurrentUser();
        if ($logged_user != null) {
            $rows = DB::select("select * from project_groups g where exists(select * from project_group_users u where g.project_group=u.project_group and u.user_id=$logged_user->id and is_manager='Y')");
            return (count($rows) > 0);
        }
        return false;       
    }

    static public function isSignoutManager() {
        $logged_user = User::getCurrentUser();
        if ($logged_user != null)
            return $logged_user->hasPermission("_signout_manager");
        return false;       
    }

    static function getProjectGroups() {        
        if (User::isSuperAdmin())
            return DB::select("select * from project_groups");
        $logged_user = User::getCurrentUser();
        return DB::select("select * from project_groups g where exists(select * from project_group_users u where g.project_group=u.project_group and u.user_id=$logged_user->id and is_manager='Y')");

    }

    static function getAllProjectGroups() {        
        return DB::select("select * from project_groups");        
    }

    static function getManagedProjects() {
        if (User::isSuperAdmin())
            return DB::select("select * from projects");
        $logged_user = User::getCurrentUser();
        return DB::select("select * from projects p where exists(select * from project_groups g, project_group_users m where p.project_group=g.project_group and g.project_group=m.project_group and m.user_id=$logged_user->id and m.is_manager='Y')");
    }
} 