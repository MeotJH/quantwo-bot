# repository.py
from api.user.entities import User


class AuthRepository:
    def get_by_email(self, email):
        return User.query.filter_by(email=email).first()