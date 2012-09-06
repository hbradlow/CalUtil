from django.conf.urls.defaults import *
from tastypie.api import Api
from myapp.api import EntryResource

api = Api(api_name='api')
api.register(EntryResource())

urlpatterns = patterns('',
    (r'^', include(v1_api.urls)),
)
