import io
import os

import pandas as pd
import pytest
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from django.urls import reverse

from rankings.models import Ranking

from django.test import TestCase, override_settings

TEST_DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",  # in-memory DB
    }
}

# class UniversityTestCase(TestCase):
#     def setUp(self):
#         Animal.objects.create(name="lion", sound="roar")
#         Animal.objects.create(name="cat", sound="meow")
#
#     def test_animals_can_speak(self):
#         """Animals that can speak are correctly identified"""
#         lion = Animal.objects.get(name="lion")
#         cat = Animal.objects.get(name="cat")
#         self.assertEqual(lion.speak(), 'The lion says "roar"')
#         self.assertEqual(cat.speak(), 'The cat says "meow"')

@override_settings(DATABASES=TEST_DATABASES)
class RankingInsertViewTestCase(TestCase):
    def setUp(self):
        self.ranking = Ranking.objects.create(ranking_name="Test Ranking")

    def test_correct_form(self):
        # Create a sample CSV in memory
        df = pd.read_csv(os.path.join('data', 'test_ranking_01.csv'))
        csv_buffer = io.StringIO()
        df.to_csv(csv_buffer, index=False)
        csv_buffer.seek(0)

        # Wrap it as an uploaded file
        uploaded_file = SimpleUploadedFile(
            "test_ranking.csv",
            csv_buffer.getvalue().encode('utf-8'),
            content_type="text/csv"
        )

        id_ranking = Ranking.objects.get(ranking_name='Test Ranking')

        # Prepare form data
        data = {
            'ranking': id_ranking,
            'dataframe': uploaded_file
        }

        # Make POST request
        response = self.client.post(reverse('ranking_insert'), data, format='multipart')

        # Check response
        self.assertEqual(response.status_code, 200)  # or 302 if your view redirects on success

        # Optionally check if success message exists
        self.assertContains(response, "success")  # adjust based on your success_insert_ranking output