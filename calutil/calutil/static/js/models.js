function generate_url(base_url,data_type,filter){
    return base_url + "?format=json"
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
                if(options)
                    options.success();
            }
        });
    },
});
NewsCollection = CalUtilCollection.extend({
    url: generate_url("/api/dailycal/"),
    initialize: function(department_id){
    },
    parse: function(data) {
        if (!data)
            return []; 
        return data;
    },
});
MenuCollection = CalUtilCollection.extend({
    url: generate_url("/app_data/menu/"),
    initialize: function(department_id){
    }
});
NewsListView = CalUtilView.extend({
    initialize: function(){
        this.el = this.options.el;
        this.collection = new NewsCollection();
        this.fetch();
    },
    render: function(){
        var e = this.el;
        $.each(this.collection.models, function(index,object){
            var template = _.template($("#news_template").html(),{name: object.attributes.title});
            $(template).appendTo($(e));
        });
        e.listview("refresh");
    }
});
MenuListView = CalUtilView.extend({
    initialize: function(){
        this.el = this.options.el;
        this.collection = new MenuCollection();
        this.fetch();
    },
    render: function(){
        var e = this.el;
        $.each(this.collection.models, function(index,object){
            var template = _.template($("#menu_template").html(),{name: object.attributes.location.name});
            $(template).appendTo($(e));
        });
        e.listview("refresh");
    }
});
CourseCollection = CalUtilCollection.extend({
    url: generate_url("/app_data/course/"),
    initialize: function(department_id){
        if(department_id)
            this.url += "&department=" + department_id;
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
        this.original_collection = this.collection;
        this.fetch();
    },
    filter: function(q){
        var new_collection = new CourseCollection();
        this.original_collection.each(function (model, index) {
            if (model.attributes.abbreviation.toLowerCase().indexOf(q.toLowerCase())!=-1) { new_collection.add(model); }
        });
        this.collection = new_collection;
        this.render();
    },
    render: function(){
        var e = this.el;
        $(e).empty();
        $.each(this.collection.models, function(index,course){
            var template = _.template($("#course_template").html(),{name: course.attributes.abbreviation,instructor: course.attributes.instructor,enrolled: course.attributes.enrolled, url: course.attributes.url});
            $(template).appendTo($(e));
        });
        e.listview("refresh");
    }
});
DepartmentListView = CalUtilView.extend({
    initialize: function(){
        this.el = this.options.el;
        this.collection = new DepartmentCollection();
        this.original_collection = this.collection;
        this.fetch();
    },
    filter: function(q){
        var new_collection = new DepartmentCollection();
        this.original_collection.each(function (model, index) {
            if (model.attributes.name.toLowerCase().indexOf(q.toLowerCase())!=-1) { new_collection.add(model); }
        });
        this.collection = new_collection;
        this.render();
    },
    render: function(){
        var e = this.el;
        $(e).empty();
        $.each(this.collection.models, function(index,object){
            var template = _.template($("#department_template").html(),{name: object.attributes.name, url: "/department/" + object.attributes.slug});
            $(template).appendTo($(e));
        });
        e.listview("refresh");
    }
});
