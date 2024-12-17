from django.contrib.auth import get_user_model
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.core.validators import EmailValidator
from django.dbutils import IntegrityError


from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny

from rest_framework import status

# Create your views here.

USER_MODEL = get_user_model()

class RegisterAppUser(GenericAPIView):
    
    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get('email', None)
        password = request.data.get('password', None)
        confirm_password = request.data.get('password2', None)
        # first_name = request.data.get('first_name', None)

        if email is None or password is None or confirm_password is None:
            return Response({'error': 'Please provide all required fields'}, status=status.HTTP_400_BAD_REQUEST)
        
        data_validation_errors = []

        if password != confirm_password:
            data_validation_errors.append("Passwords don't match")
        
        try: 
            validator = EmailValidator()
            validator(email)
        except ValidationError as e:
            print(e)
            data_validation_errors.append(e.messages)

        if len(data_validation_errors) > 0:
            return Response(data_validation_errors, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            user = USER_MODEL.objects.create_user(email=email, password=password)
        except IntegrityError as e:
            return Response(f'User {email} already exists', status=status.HTTP_409_CONFLICT)
        
        # success = send_activation_email(user)

        # if not success:
        #     return Response("Could not send email", status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        return Response(f'Success. An activation email has been sent to: {email}', status=status.HTTP_201_CREATED)
            




        



