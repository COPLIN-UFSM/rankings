from django.urls import path
from . import views

urlpatterns = [
    path("", views.IndexView.as_view(), name='index'),
    path("ranking/", views.IndexView.as_view(), name='index'),
    path("ranking/insert/", views.RankingInsertView.as_view(), name='ranking-insert'),
    path("countries/list", views.CountriesListView.as_view(), name='countries-list'),
    path("countries/missing/", views.MissingCountriesPreview.as_view(), name='missing-countries'),
    path("ranking/insert/result/", views.ResultInsertRankingView.as_view(), name='ranking-insert-result'),
    path("universities/merge", views.MergeUniversitiesView.as_view(), name='universities-merge'),
    path("universities/list/<int:id_pais>", views.UniversitiesListView.as_view(), name="universities-list"),
    path("universities/similar/<int:id_universidade>", views.UniversitiesSimilarView.as_view(), name="universities-similar"),
]