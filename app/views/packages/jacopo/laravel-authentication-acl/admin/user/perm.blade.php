{{-- add permission --}}
<div id='loading_perm' class='loading_img' style="display: none;">
    <h4 style="display:inline">Processing...</h4><img width=30 height=30 src='{{url('/images/ajax-loader.gif')}}'></img>
</div>
{{Form::open(["route" => "users.edit.permission","role"=>"form", 'class' => 'form-add-perm'])}}
<div class="form-group">
    <div class="input-group">
        <span class="input-group-addon form-button button-add-perm"><span class="glyphicon glyphicon-plus-sign add-input"></span></span>
        <select class="form-control permission-select" name="permissions">
        @foreach ($permission_values as $permission_value => $permission_name)
            @if (! array_key_exists($permission_value, $user->permissions))
            <option value="{{$permission_value}}">{{$permission_name}}</option>
            @endif
        @endforeach
        </select>
        <span id="project_group" class="form-control" style="display:none">&nbsp;Project groups: &nbsp;
        @foreach($project_groups as $project_group)
            <input type="checkbox" name="{{$project_group->project_group}}" value="{{$project_group->project_group}}" >&nbsp;{{$project_group->name}}&nbsp;</input>
        @endforeach
        </span>
    </div>
    <span class="text-danger">{{$errors->first('permissions')}}</span>
    {{Form::hidden('id', $user->id)}}
    {{-- add permission operation --}}
    {{Form::hidden('operation', 1)}}    
</div>
@if(! $user->exists)
<div class="form-group">
    <span class="text-danger"><h5>You need to create the user first.</span>
</div>
@endif
{{Form::close()}}

{{-- remove permission --}}
@if( $presenter->permissions )
@foreach($presenter->permissions_obj as $permission)
{{Form::open(["route" => "users.edit.permission", "name" => $permission->permission, "role"=>"form"])}}
<div class="form-group">
    <div class="input-group">
        <span class="input-group-addon form-button button-del-perm" name="{{$permission->permission}}"><span class="glyphicon glyphicon-minus-sign add-input"></span></span>
        {{Form::text('permission_desc', $permission->description, ['class' => 'form-control', 'readonly' => 'readonly'])}}        
        {{Form::hidden('permissions', $permission->permission)}}
        {{Form::hidden('id', $user->id)}}
        {{-- add permission operation --}}
        {{Form::hidden('operation', 0)}}
    </div>    
</div>
{{Form::close()}}
@if ($permission->permission == "_projectmanager")
    {{Form::open(["route" => "users.edit.permission", "name" => "edit_project_manager", "role"=>"form"])}}
    <div class="form-group">
        <div class="input-group">
            <span class="input-group-addon form-button button-del-perm" name="{{$permission->permission}}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="fa fa-edit add-input" style="font-size: 1.5em;"></span></span>
            <div id="project_group" class="form-control">&nbsp;Project groups: &nbsp;
            @foreach($project_groups as $project_group)
                <input type="checkbox" name="{{$project_group->project_group}}" value="{{$project_group->project_group}}" {{$project_group->checked}} >&nbsp;{{$project_group->name}}&nbsp;</input>
            @endforeach
            </div>
        </div>
    </div>
    {{Form::hidden('permissions', $permission->permission)}}
    {{Form::hidden('id', $user->id)}}
    {{Form::hidden('operation', 2)}}
    {{Form::close()}}
@endif

@endforeach
@elseif($user->exists)
<span class="text-warning"><h5>There is no permission associated to the user.</h5></span>
@endif

@section('footer_scripts')
@parent
<script>
    $('select[name="permissions"').change(function() {
        if ($(this).val() == "_projectmanager")
            $('#project_group').css("display","block"); 
        else
            $('#project_group').css("display","none"); 
    });
    $(".button-add-perm").click(function () {
        $("#loading_perm").css("display","block");
        <?php if($user->exists): ?>
        $('.form-add-perm').submit();
        <?php endif; ?>
    });
    $(".button-del-perm").click(function () {
        $("#loading_perm").css("display","block");
        // submit the form with the same name
        name = $(this).attr('name');
        $('form[name='+name+']').submit();
    });
</script>
@stop