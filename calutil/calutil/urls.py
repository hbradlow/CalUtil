from django.conf.urls import patterns, include, url
from tastypie.api import Api
from api.API import *

from django.contrib import admin
admin.autodiscover()

api = Api(api_name='app_data')
api.register(RSFRoomResource())
api.register(BusLineResource())
api.register(BusStopResource())
api.register(CalOneCardLocationResource())
api.register(CourseResource())
api.register(DepartmentResource())
api.register(WebcastResource())
api.register(MenuItemResource())
api.register(MenuResource())
api.register(LocationResource())
api.register(SectionResource())

urlpatterns = patterns('',
    #django
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^admin/', include(admin.site.urls)),

    #project
    (r'^', include(api.urls)),
    (r'^api/', include("api.urls")),
    (r'^', include("web.urls")),
)
