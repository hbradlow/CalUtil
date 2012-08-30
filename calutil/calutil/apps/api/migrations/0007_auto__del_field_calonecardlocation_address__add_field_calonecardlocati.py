# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Deleting field 'CalOneCardLocation.address'
        db.delete_column('api_calonecardlocation', 'address')

        # Adding field 'CalOneCardLocation.times'
        db.add_column('api_calonecardlocation', 'times',
                      self.gf('django.db.models.fields.CharField')(default=0, max_length=200),
                      keep_default=False)

        # Adding field 'CalOneCardLocation.info'
        db.add_column('api_calonecardlocation', 'info',
                      self.gf('django.db.models.fields.TextField')(default=0),
                      keep_default=False)


    def backwards(self, orm):
        # Adding field 'CalOneCardLocation.address'
        db.add_column('api_calonecardlocation', 'address',
                      self.gf('django.db.models.fields.CharField')(default=0, max_length=1000),
                      keep_default=False)

        # Deleting field 'CalOneCardLocation.times'
        db.delete_column('api_calonecardlocation', 'times')

        # Deleting field 'CalOneCardLocation.info'
        db.delete_column('api_calonecardlocation', 'info')


    models = {
        'api.busline': {
            'Meta': {'object_name': 'BusLine'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        'api.busline2': {
            'Meta': {'object_name': 'BusLine2'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'line_tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'line_title': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'vehicles': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.BusVehicle']", 'symmetrical': 'False'})
        },
        'api.busstop': {
            'Meta': {'object_name': 'BusStop'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'lines': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.BusLine']", 'symmetrical': 'False'}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'stop_id': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        'api.busstopdirection': {
            'Meta': {'object_name': 'BusStopDirection'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'line': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['api.BusLine']"}),
            'tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        'api.busvehicle': {
            'Meta': {'object_name': 'BusVehicle'},
            'dir_tag': ('django.db.models.fields.CharField', [], {'max_length': '10', 'null': 'True'}),
            'heading': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'predictable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'route_tag': ('django.db.models.fields.CharField', [], {'max_length': '10'}),
            'seconds_since_report': ('django.db.models.fields.IntegerField', [], {}),
            'speed': ('django.db.models.fields.FloatField', [], {}),
            'vehicle_id': ('django.db.models.fields.IntegerField', [], {})
        },
        'api.calonecardlocation': {
            'Meta': {'object_name': 'CalOneCardLocation'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'image_url': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'info': ('django.db.models.fields.TextField', [], {}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '300'}),
            'times': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '200'})
        },
        'api.course': {
            'Meta': {'object_name': 'Course'},
            'abbreviation': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '500', 'null': 'True'}),
            'available_seats': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'ccn': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'days': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'enrolled': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'exam_group': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'instructor': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'limit': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'number': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '50', 'null': 'True'}),
            'pnp': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'section': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'semester': ('django.db.models.fields.CharField', [], {'default': "'Spring'", 'max_length': '30', 'null': 'True'}),
            'time': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '500', 'null': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'units': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'waitlist': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'year': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'})
        },
        'api.diningtime': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'DiningTime'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'locations': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.Location']", 'symmetrical': 'False'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'api.location': {
            'Meta': {'object_name': 'Location'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'timespans': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.TimeSpan']", 'symmetrical': 'False'})
        },
        'api.menu': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'Menu'},
            'breakfast': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'breakfast'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'brunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'brunch'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'dinner': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'dinner'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'lunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'lunch'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'api.menuitem': {
            'Meta': {'object_name': 'MenuItem'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.CharField', [], {'default': "'#'", 'max_length': '1000'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "'Normal'", 'max_length': '50'})
        },
        'api.section': {
            'Meta': {'object_name': 'Section'},
            'available_seats': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'ccn': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'enrolled': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'exam_group': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'instructor': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'limit': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'time': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'units': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'waitlist': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'})
        },
        'api.timespan': {
            'Meta': {'object_name': 'TimeSpan'},
            'days': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'span': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        'api.webcast': {
            'Meta': {'object_name': 'Webcast'},
            'description': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'number': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'url': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '1000', 'null': 'True'})
        }
    }

    complete_apps = ['api']