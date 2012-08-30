from django.conf.urls.defaults import *
urlpatterns = patterns('api.views',
    url(r'^bus_stop/predictions/(?P<stop_id>(\d+))/$',"predictions",name="bus_predictions"),
)
