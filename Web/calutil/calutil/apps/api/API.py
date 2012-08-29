from django.contrib.auth.models import User
from tastypie.resources import ModelResource
from api.models import BusStop


class BusStopResource(ModelResource):
    class Meta:
        queryset = BusStop.objects.all()
        resource_name = 'bus_stop'
