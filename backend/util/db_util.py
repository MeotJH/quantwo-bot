def with_to_dict(cls):
    def to_dict(self):
        return {
            column.name: getattr(self, column.name)
            for column in self.__table__.columns
        }
    cls.to_dict = to_dict
    return cls
