import datetime
def flatten(l):
    return [i for sublist in l for i in sublist]
def time_period(start,end,increment):
    import datetime
    datetime_start = datetime.datetime(1,1,1,start.hour,start.minute)
    datetime_end = datetime.datetime(1,1,1,end.hour,end.minute)
    if datetime_start==datetime_end:
        yield datetime_start
    else:
        while datetime_start <= datetime_end:
            yield datetime_start
            datetime_start += increment


p_times = {
        "times": flatten([
            [t for t in time_period(datetime.time(6,45),datetime.time(11,0),datetime.timedelta(minutes=15))],
            [t for t in time_period(datetime.time(11,30),datetime.time(16,0),datetime.timedelta(minutes=30))],
            [t for t in time_period(datetime.time(16,15),datetime.time(19,30),datetime.timedelta(minutes=15))],
        ]),
        "offsets": [
            0,2,4,5,6,8,10,11,12,14,18,20,21,23,25,27,28
        ]
}
h_times = {
        "times": flatten([
            [t for t in time_period(datetime.time(7,40),datetime.time(18,10),datetime.timedelta(minutes=30))],
            [t for t in time_period(datetime.time(19,0),datetime.time(19,0),datetime.timedelta(minutes=0))],
        ]),
        "offsets": [
            0,5,7,9,11,15,17,19,21
        ]
}


o = {"P":{},"H":{}}
def stringify(dt):
    h = str(dt.time().hour)
    m = str(dt.time().minute)
    if dt.time().hour < 10:
        h = "0"+h
    if dt.time().minute < 10:
        m = "0"+m
    return str(h) + ":" + str(m)

s = "a"
for offset in p_times['offsets']:
    td = datetime.timedelta(minutes=offset)
    o["P"][s] = [stringify(t+td) for t in p_times['times']]
    s = chr(ord(s)+1)

s = "b"
for offset in h_times['offsets']:
    td = datetime.timedelta(minutes=offset)
    o["H"][s] = [stringify(t+td) for t in h_times['times']]
    s = chr(ord(s)+1)
import json
print json.dumps(o)
