from django.conf.urls import patterns, include, url
from django.views.generic.simple import direct_to_template

from django.views.generic import DetailView
from api.models import Department,Course

urlpatterns = patterns('web.views',
        url(r'^$', direct_to_template, {"template":"web/home.html"},name="home"),
        url(r'^department/(?P<slug>[\w\._-]+)/$', DetailView.as_view(model=Department,template_name="web/courses.html"),name="department_detail"),
        url(r'^course/(?P<pk>[\d]+)/$', DetailView.as_view(model=Course,template_name="web/course_detail.html"),name="course_detail"),

        url(r'^menu/(?P<name>[\w]+)/$', "menu_detail" ,name="menu_detail"),
        url(r'^menu_item/(?P<item_id>[\d]+)/$', "menu_item_detail" ,name="menu_item_detail"),
)
