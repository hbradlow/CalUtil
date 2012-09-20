from django.conf.urls import patterns, include, url
from django.views.generic.simple import direct_to_template

from django.views.generic import DetailView
from api.models import Department

urlpatterns = patterns('web.views',
        url(r'^$', direct_to_template, {"template":"web/home.html"},name="home"),
        url(r'^department/(?P<slug>[\w\._-]+)/$', DetailView.as_view(model=Department,template_name="web/courses.html"),name="home"),
)
