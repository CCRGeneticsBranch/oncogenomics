<?php

/*
|--------------------------------------------------------------------------
| Application & Route Filters
|--------------------------------------------------------------------------
|
| Below you will find the "before" and "after" events for the application
| which may be used to do any work before or after a request into your
| application. Here you may also register your custom route filters.
|
*/

App::before(function($request)
{
	//
});


App::after(function($request, $response)
{
	//
});

/*
|--------------------------------------------------------------------------
| Authentication Filters
|--------------------------------------------------------------------------
|
| The following filters are used to verify that the user of the current
| session is logged into this application. The "basic" filter easily
| integrates HTTP Basic authentication for quick, simple checking.
|
*/

Route::filter('auth', function()
{
	if (Auth::guest())
	{
		if (Request::ajax())
		{
			return Response::make('Unauthorized', 401);
		}
		else
		{
			return Redirect::guest('login');
		}
	}
});


Route::filter('auth.basic', function()
{
	return Auth::basic();
});

/*
|--------------------------------------------------------------------------
| Guest Filter
|--------------------------------------------------------------------------
|
| The "guest" filter is the counterpart of the authentication filters as
| it simply checks that the current user is not logged in. A redirect
| response will be issued if they are, which you may freely change.
|
*/

Route::filter('guest', function()
{
	if (Auth::check()) return Redirect::to('/');
});

Route::filter('authorized_token', function($route)
{
	//$token = $route->getParameter('token');
	$data = Input::all();
	if (!array_key_exists("token", $data))
		return '{"status":"token required"}';
	$token = $data["token"];
	if ($token != Config::get("site.token"))
		return '{"status":"invalid token"}';
});

Route::filter('authorized_project', function($route)
{
	$logged_user = User::getCurrentUser();
	if ($logged_user == null)
		return Redirect::to('/');
	$project_id = $route->getParameter('project_id');
	if (!User::hasProject($project_id)) {
		return View::make('pages/error', ['message' => "Project $project_id not found or unauthorized"]);
	}
	//Log::info("project_id: $project_id");
	//return "OK";
});

Route::filter('authorized_patient', function($route)
{
	$patient_id = $route->getParameter('patient_id');
	if (!User::hasPatient($patient_id)) {
		return View::make('pages/error', ['message' => "Patient_id $patient_id not found or unauthorized"]);
	}
	//Log::info("patient_id: $patient_id");
	//return "OK";
});


/*
|--------------------------------------------------------------------------
| CSRF Protection Filter
|--------------------------------------------------------------------------
|
| The CSRF filter is responsible for protecting your application against
| cross-site request forgery attacks. If this special token in a user
| session does not match the one given in this request, we'll bail.
|
*/

Route::filter('csrf', function()
{
	if (Session::token() != Input::get('_token'))
	{
		Redirect::to('/login');
		//throw new Illuminate\Session\TokenMismatchException;
	}
});
