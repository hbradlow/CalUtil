from django.conf.urls import patterns, include, url
from tastypie.api import Api
from api.API import BusStopResource

from django.contrib import admin
admin.autodiscover()

api = Api(api_name='api')
api.register(BusStopResource())

urlpatterns = patterns('',
    #django
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^admin/', include(admin.site.urls)),

    #project
    (r'^', include(api.urls)),
)
