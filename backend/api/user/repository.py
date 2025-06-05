from api.user.entities import User
from api import db
from sqlalchemy.exc import IntegrityError
from exceptions import UserAlreadyExistException

class UserRepository:
    def get_by_email(self, email):
        return User.query.filter_by(email=email).first()
    
    def save(self, user_data: dict) -> User:
        try:
            user = User(**user_data)
            db.session.add(user)
            db.session.commit()
            return user
        except IntegrityError:
            db.session.rollback()
            raise UserAlreadyExistException("중복된 메일입니다", 409)
