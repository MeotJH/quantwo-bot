import uuid

def with_to_dict(cls):
    def to_dict(self):
        result = {}
        for column in self.__table__.columns:
            value = getattr(self, column.name)
            # UUID 객체를 문자열로 변환
            if isinstance(value, uuid.UUID):
                result[column.name] = str(value)
            else:
                result[column.name] = value
        return result
    cls.to_dict = to_dict
    return cls
