# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'BusLine2'
        db.create_table('api_busline2', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('line_title', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('line_tag', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('api', ['BusLine2'])

        # Adding M2M table for field vehicles on 'BusLine2'
        db.create_table('api_busline2_vehicles', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('busline2', models.ForeignKey(orm['api.busline2'], null=False)),
            ('busvehicle', models.ForeignKey(orm['api.busvehicle'], null=False))
        ))
        db.create_unique('api_busline2_vehicles', ['busline2_id', 'busvehicle_id'])

        # Adding field 'BusStop.line'
        db.add_column('api_busstop', 'line',
                      self.gf('django.db.models.fields.related.ForeignKey')(default=0, to=orm['api.BusLine']),
                      keep_default=False)

        # Deleting field 'BusLine.line_title'
        db.delete_column('api_busline', 'line_title')

        # Deleting field 'BusLine.line_tag'
        db.delete_column('api_busline', 'line_tag')

        # Adding field 'BusLine.title'
        db.add_column('api_busline', 'title',
                      self.gf('django.db.models.fields.CharField')(default=0, max_length=100),
                      keep_default=False)

        # Adding field 'BusLine.tag'
        db.add_column('api_busline', 'tag',
                      self.gf('django.db.models.fields.CharField')(default=0, max_length=50),
                      keep_default=False)

        # Removing M2M table for field vehicles on 'BusLine'
        db.delete_table('api_busline_vehicles')


    def backwards(self, orm):
        # Deleting model 'BusLine2'
        db.delete_table('api_busline2')

        # Removing M2M table for field vehicles on 'BusLine2'
        db.delete_table('api_busline2_vehicles')

        # Deleting field 'BusStop.line'
        db.delete_column('api_busstop', 'line_id')

        # Adding field 'BusLine.line_title'
        db.add_column('api_busline', 'line_title',
                      self.gf('django.db.models.fields.CharField')(default=0, max_length=50),
                      keep_default=False)

        # Adding field 'BusLine.line_tag'
        db.add_column('api_busline', 'line_tag',
                      self.gf('django.db.models.fields.CharField')(default=0, max_length=50),
                      keep_default=False)

        # Deleting field 'BusLine.title'
        db.delete_column('api_busline', 'title')

        # Deleting field 'BusLine.tag'
        db.delete_column('api_busline', 'tag')

        # Adding M2M table for field vehicles on 'BusLine'
        db.create_table('api_busline_vehicles', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('busline', models.ForeignKey(orm['api.busline'], null=False)),
            ('busvehicle', models.ForeignKey(orm['api.busvehicle'], null=False))
        ))
        db.create_unique('api_busline_vehicles', ['busline_id', 'busvehicle_id'])


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
            'line': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['api.BusLine']"}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'stop_id': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
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
            'address': ('django.db.models.fields.CharField', [], {'max_length': '1000'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'image_url': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '300'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '200'})
        },
        'api.course': {
            'Meta': {'object_name': 'Course'},
            'abbreviation': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '50', 'null': 'True'}),
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
            'sections': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.Section']", 'symmetrical': 'False'}),
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