from django.contrib.auth.models import User
from tastypie.authorization import Authorization
from tastypie import fields
from tastypie.resources import ModelResource,ALL_WITH_RELATIONS,ALL
from api.models import *

class RSFRoomResource(ModelResource):
    class Meta:
        queryset = RSFRoom.objects.all()
        list_allowed_methods = ['get', 'post']
        detail_allowed_methods = ['get', 'post']
        resource_name = 'rsf_room'
        authorization= Authorization()
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
def filter_timespan_for_today(times):
    import re
    import datetime
    matches = {
        "monday":       0,
        "tuesday":      1,
        "wednesday":    2,
        "thursday":     3,
        "friday":       4,
        "saturday":     5,
        "sunday":       6,
    }
    bundles = []
    for time in times:
        try:
            d = re.match(r'\s*(\w+)\s*(-\s*(\w+))?\s*',time.obj.days)
            first = matches[d.group(1).lower()]
            try:
                last = matches[d.group(3).lower()]
            except:
                last = None
            current = datetime.datetime.now().weekday()
            if not last and current == first:
                bundles.append(time)
            elif current >= first and current <= last:
                bundles.append(time)
        except:
            pass #something went wrong, dont add this to the bundle
    return bundles

class LibraryResource(ModelResource):
    class Meta:
        queryset = Library.objects.all()
        resource_name = "library"

class CampusBuildingResource(ModelResource):
    def dehydrate(self,bundle):
        bundle.data['image_url'] = "http://www.berkeley.edu/map/3dmap/" + bundle.data['abbreviation'] + ".jpg"
        return bundle
    class Meta:
        queryset = CampusBuilding.objects.all()
        resource_name = "building"
class CalOneCardLocationResource(ModelResource):
    times = fields.ToManyField("api.API.TimeSpanResource","timespans",null=True,full=True)
    def dehydrate(self, bundle):
        bundle.data['times'] = filter_timespan_for_today(bundle.data['times'])
        return bundle
    class Meta:
        queryset = CalOneCardLocation.objects.all()
        resource_name = "cal_one_card"

class SectionResource(ModelResource):
    course = fields.ToOneField("api.API.CourseResource","course")
    class Meta:
        queryset = Section.objects.all()
        resource_name = "section"
        filtering = {
            'course':['exact'],
            'limit':['exact'],
            'offset':['exact'],
            'id':ALL,
        }
class CourseResource(ModelResource):
    department = fields.ToOneField("api.API.DepartmentResource","department")
    def dehydrate(self, bundle):
        bundle.data['url'] = bundle.obj.get_absolute_url()
        bundle.data['webcast_flag'] = bundle.obj.webcast_set.count() > 0
        try:
            bundle.data['building'] = bundle.obj.building.name
        except:
            pass
        try:
            bundle.data['latitude'] = bundle.obj.building.latitude
            bundle.data['longitude'] = bundle.obj.building.longitude
        except:
            pass #probably obj doesnt have a building
        return bundle
    class Meta:
        queryset = Course.objects.all()
        resource_name = "course"
        filtering = {
            'department':['exact'],
            'limit':['exact'],
            'offset':['exact'],
            'id':ALL,
        }
class DepartmentResource(ModelResource):
    class Meta:
        queryset = Department.objects.all()
        resource_name = "department"

class WebcastResource(ModelResource):
    course = fields.ToOneField("api.API.CourseResource","course")
    class Meta:
        queryset = Webcast.objects.all()
        resource_name = "webcast"
        filtering = {
            'course':['exact'],
            'limit':['exact'],
            'offset':['exact']
        }

class MenuItemResource(ModelResource):
    class Meta:
        queryset = MenuItem.objects.all()
        resource_name = "menu_item"
class TimeSpanResource(ModelResource):
    class Meta:
        queryset = TimeSpan.objects.all()
        resource_name = "location"

class LocationResource(ModelResource):
    breakfast_times = fields.ToManyField("api.API.TimeSpanResource","breakfast_times",null=True,full=True)
    lunch_times = fields.ToManyField("api.API.TimeSpanResource","lunch_times",null=True,full=True)
    dinner_times = fields.ToManyField("api.API.TimeSpanResource","dinner_times",null=True,full=True)
    brunch_times = fields.ToManyField("api.API.TimeSpanResource","brunch_times",null=True,full=True)
    latenight_times = fields.ToManyField("api.API.TimeSpanResource","latenight_times",null=True,full=True)
    def dehydrate(self, bundle):
        bundle.data['breakfast_times'] = filter_timespan_for_today(bundle.data['breakfast_times'])
        bundle.data['lunch_times'] = filter_timespan_for_today(bundle.data['lunch_times'])
        bundle.data['dinner_times'] = filter_timespan_for_today(bundle.data['dinner_times'])
        bundle.data['brunch_times'] = filter_timespan_for_today(bundle.data['brunch_times'])
        bundle.data['latenight_times'] = filter_timespan_for_today(bundle.data['latenight_times'])
        return bundle
    class Meta:
        queryset = Location.objects.all()
        resource_name = "location"
class MenuResource(ModelResource):
    breakfast_items = fields.ToManyField("api.API.MenuItemResource","breakfast",full=True)
    brunch_items = fields.ToManyField("api.API.MenuItemResource","brunch",full=True)
    lunch_items = fields.ToManyField("api.API.MenuItemResource","lunch",full=True)
    dinner_items = fields.ToManyField("api.API.MenuItemResource","dinner",full=True)
    location = fields.ToOneField("api.API.LocationResource","location",full=True)
    class Meta:
        queryset = Menu.objects.all()
        resource_name = "menu"
        filtering = {
            'location':['exact'],
            'limit':['exact'],
            'offset':['exact'],
            'id':ALL,
        }
