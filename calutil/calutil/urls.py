from django.conf.urls import patterns, include, url
from tastypie.api import Api
from api.API import BusStopResource,BusLineResource, CalOneCardLocationResource, CourseResource, DepartmentResource

from django.contrib import admin
admin.autodiscover()

api = Api(api_name='api')
api.register(BusLineResource())
api.register(BusStopResource())
api.register(CalOneCardLocationResource())
api.register(CourseResource())
api.register(DepartmentResource())

urlpatterns = patterns('',
    #django
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^admin/', include(admin.site.urls)),

    #project
    (r'^', include(api.urls)),
    (r'^', include("api.urls")),
)
