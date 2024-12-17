from django.urls import path
from . import views

app_name = 'api'

urlpatterns = [
    path('register/', views.RegisterAppUser.as_view(), name='registration')
]

