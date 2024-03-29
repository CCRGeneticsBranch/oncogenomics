<?php  namespace Jacopo\Authentication\Controllers;
/**
 * Class GroupController
 *
 * @author jacopo beschi jacopo@jacopobeschi.com
 */
use Illuminate\Support\MessageBag;
use Jacopo\Authentication\Presenters\GroupPresenter;
use Jacopo\Library\Form\FormModel;
use Jacopo\Authentication\Helpers\FormHelper;
use Jacopo\Authentication\Models\Group;
use Jacopo\Authentication\Models\User;
use Jacopo\Authentication\Exceptions\UserNotFoundException;
use Jacopo\Authentication\Validators\GroupValidator;
use Jacopo\Library\Exceptions\JacopoExceptionsInterface;
use View, Input, Redirect, App, Config;
use DB, Log;

class GroupController extends \Controller
{
    /**
     * @var \Jacopo\Authentication\Repository\SentryGroupRepository
     */
    protected $group_repository;
    /**
     * @var \Jacopo\Authentication\Validators\GroupValidator
     */
    protected $group_validator;
    /**
     * @var FormHelper
     */
    protected $form_model;

    public function __construct(GroupValidator $v, FormHelper $fh)
    {
        $this->group_repository = App::make('group_repository');
        $this->group_validator = $v;
        $this->f = new FormModel($this->group_validator, $this->group_repository);
        $this->form_model = $fh;
    }

    public function getList()
    {
        $groups = $this->group_repository->all(Input::all());
        $logged_user = User::getCurrentUser();
        $sql = "select * from projects p where exists(select * from project_groups g, project_group_users m where p.project_group=g.project_group and g.project_group=m.project_group and m.is_manager='Y' and m.user_id=$logged_user->id) order by name";
        if (User::isSuperAdmin())
            $sql = "select * from projects order by name";
        Log::info($sql);
        $groups = DB::select($sql);

        return View::make('laravel-authentication-acl::admin.group.list')->with(["groups" => $groups]);
    }

    public function editGroup()
    {
        try
        {
            $obj = $this->group_repository->find(Input::get('id'));
        }
        catch(UserNotFoundException $e)
        {
            $obj = new Group;
        }
        $presenter = new GroupPresenter($obj);

        return View::make('laravel-authentication-acl::admin.group.edit')->with(["group" => $obj, "presenter" => $presenter]);
    }

    public function postEditGroup()
    {
        $id = Input::get('id');
        $ispublic = Input::get('ispublic');
        $desc = Input::get('description');
        
        try
        {
            #$obj = $this->f->process(Input::all());
            DB::statement("update projects set ispublic=$ispublic,description='$desc' where id=$id");
            DB::statement("BEGIN Dbms_Mview.Refresh('USER_PROJECTS','C');END;");

        }
        catch(JacopoExceptionsInterface $e)
        {
            $errors = $this->f->getErrors();
            // passing the id incase fails editing an already existing item
            return Redirect::route("groups.edit", $id ? ["id" => $id]: [])->withInput()->withErrors($errors);
        }
        return Redirect::action('Jacopo\Authentication\Controllers\GroupController@editGroup',["id" => $id, "ispublic" => $ispublic])->withMessage(Config::get('laravel-authentication-acl::messages.flash.success.group_edit_success'));
    }

    public function deleteGroup()
    {
        try
        {
            $this->f->delete(Input::all());
        }
        catch(JacopoExceptionsInterface $e)
        {
            $errors = $this->f->getErrors();
            return Redirect::action('Jacopo\Authentication\Controllers\GroupController@getList')->withErrors($errors);
        }
        return Redirect::action('Jacopo\Authentication\Controllers\GroupController@getList')->withMessage(Config::get('laravel-authentication-acl::messages.flash.success.group_delete_success'));
    }

    public function editPermission()
    {
        // prepare input
        $input = Input::all();
        $operation = Input::get('operation');
        $this->form_model->prepareSentryPermissionInput($input, $operation);
        $id = Input::get('id');

        try
        {
            $obj = $this->group_repository->update($id, $input);
            DB::statement("BEGIN Dbms_Mview.Refresh('USER_PROJECTS','C');END;");
        }
        catch(JacopoExceptionsInterface $e)
        {
            return Redirect::route("users.groups.edit")->withInput()->withErrors(new MessageBag(["permissions" => Config::get('laravel-authentication-acl::messages.flash.error.group_permission_not_found')]));
        }
        return Redirect::action('Jacopo\Authentication\Controllers\GroupController@editGroup',["id" => $obj->id])->withMessage(Config::get('laravel-authentication-acl::messages.flash.success.group_permission_edit_success'));
    }
}
