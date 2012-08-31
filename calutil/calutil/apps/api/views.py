from django.shortcuts import *
import json
from api.models import *
from django.db.models import Q

def predictions(request,stop_id,line_tag):
    stop = BusStop.objects.get(stop_id=stop_id)
    return HttpResponse(json.dumps(sorted([int(object['minutes']) for object in stop.predictions()['objects'] if object['line']==line_tag])[:3]))
