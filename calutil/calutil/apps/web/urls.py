from django.conf.urls import patterns, include, url
from django.views.generic.simple import direct_to_template

urlpatterns = patterns('web.views',
        url(r'^$', direct_to_template, {"template":"web/home.html"},name="home"),
)
