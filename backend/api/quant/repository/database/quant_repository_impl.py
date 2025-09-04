from api.quant.domain.entities import Quant


class QuantRepositoryImpl():
    
    def find_by_user_uuid(self, user_uuid):
        """ 사용자 uuid로 퀀트목록 조회"""
        return Quant.query.filter_by(user_id=user_uuid).all()