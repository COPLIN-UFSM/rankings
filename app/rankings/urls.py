from django.urls import path
from . import views

urlpatterns = [
    path("", views.IndexView.as_view(), name='index'),
    path("ranking/", views.IndexView.as_view(), name='index'),
    path("ranking/insert/", views.RankingInsertView.as_view(), name='ranking-insert'),
    path("countries/missing/preview/", views.MissingCountriesPreview.as_view(), name='missing-countries-preview'),
    path("ranking/insert/success/", views.SuccessInsertRankingView.as_view(), name='ranking-insert-success')
]