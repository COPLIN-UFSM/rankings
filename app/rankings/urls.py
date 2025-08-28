from django.urls import path
from . import views

urlpatterns = [
    path("", views.IndexView.as_view(), name="index"),
    path("ranking/insert/", views.RankingInsertView.as_view(), name="ranking"),
    path("ranking/insert/success/", views.success_insert_ranking, name="success")
]