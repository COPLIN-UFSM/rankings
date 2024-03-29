from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("ranking/insert/", views.ranking_insert, name="ranking"),
    path("ranking/insert/success/", views.success_insert_ranking, name="success"),
    path("pillars/merger/preview/", views.MergerPillarsPreview.as_view(), name="preview_replicate_pillars"),
    # path("countries/missing/preview/", views.missing_countries_preview, name="preview_missing_countries"),
    path("countries/missing/insert/", views.missing_countries_insert, name="insert_missing_countries"),
    path("universities/merger/preview/", views.merger_universities_preview, name="preview_replicate_universities"),
    path("universities/merger/insert/", views.merger_universities_insert, name="insert_replicate_universities"),
    path("universities/duplicate/preview/", views.duplicate_universities_preview, name="preview_duplicate_universities"),
    path("universities/duplicate/insert/", views.duplicate_universities_insert, name="insert_duplicate_universities"),
    path("universities/duplicate/success", views.success_remove_duplicate_universities, name="success"),
]