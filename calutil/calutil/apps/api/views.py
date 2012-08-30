from django.shortcuts import *
import json
from api.models import *

def predictions(request,stop_id):
    stop = BusStop.objects.get(stop_id=stop_id)
    return HttpResponse(json.dumps(stop.predictions()))
