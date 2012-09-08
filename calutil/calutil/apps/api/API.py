from django.contrib.auth.models import User
from tastypie import fields
from tastypie.resources import ModelResource,ALL_WITH_RELATIONS
from api.models import BusStop, BusLine,CalOneCardLocation, Course, Department

class BusLineResource(ModelResource):
    class Meta:
        queryset = BusLine.objects.all()
        resource_name = 'bus_line'
class BusStopResource(ModelResource):
    lines = fields.ToManyField("api.API.BusLineResource","lines",full=True)
    class Meta:
        queryset = BusStop.objects.all()
        list_allowed_methods = ['get', 'post']
        detail_allowed_methods = ['get', 'post']
        resource_name = 'bus_stop'
class CalOneCardLocationResource(ModelResource):
    class Meta:
        queryset = CalOneCardLocation.objects.all()
        resource_name = "cal_one_card"

class CourseResource(ModelResource):
    department = fields.ToOneField("api.API.DepartmentResource","department")
    class Meta:
        queryset = Course.objects.all()
        resource_name = "course"
        filtering = {
            'department':['exact'],
            'limit':['exact'],
            'offset':['exact']
        }
class DepartmentResource(ModelResource):
    class Meta:
        queryset = Department.objects.all()
        resource_name = "department"
