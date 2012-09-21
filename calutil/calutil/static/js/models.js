function generate_url(base_url,data_type,filter){
    return base_url + "?format=json&limit=20"
}
CalUtilCollection = Backbone.Collection.extend({
    parse: function(data) {
        if (!data)
            return []; 
        this.url = data.meta.next;
        if(!this.url)
            this.complete = true;
        return data.objects;//parse out the objects list
    },
});
CalUtilView = Backbone.View.extend({
    fetch: function(options){
        var view = this;
        if(this.collection.complete)
            options.complete();
        this.collection.fetch({
            success: function(data){
                view.render();
                options.success();
            }
        });
    },
});
CourseCollection = CalUtilCollection.extend({
    url: generate_url("/app_data/course/"),
    initialize: function(department_id){
        if(department_id)
            this.url += "&department=" + department_id;
        console.log(this.url);
    }
});
DepartmentCollection = CalUtilCollection.extend({
    url: generate_url("/app_data/department/"),
});
CourseListView = CalUtilView.extend({
    initialize: function(){
        this.el = this.options.el;
        if(this.options.collection)
            this.collection = this.options.collection;
        else
            this.collection = new CourseCollection();
        this.fetch();
    },
    render: function(){
        var e = this.el;
        $.each(this.collection.models, function(index,course){
            var template = _.template($("#course_template").html(),{name: course.attributes.abbreviation,instructor: course.attributes.instructor,enrolled: course.attributes.enrolled, url: course.attributes.url});
            $(template).appendTo($(e));
        });
    }
});
DepartmentListView = CalUtilView.extend({
    initialize: function(){
        this.el = this.options.el;
        this.collection = new DepartmentCollection();
        this.fetch();
    },
    render: function(){
        var e = this.el;
        $.each(this.collection.models, function(index,object){
            var template = _.template($("#department_template").html(),{name: object.attributes.name, url: "/department/" + object.attributes.slug});
            $(template).appendTo($(e));
        });
        e.listview("refresh");
    }
});
