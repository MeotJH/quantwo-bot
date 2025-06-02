import logging
import sys

class __LoggingWrapper:
    def __init__(self):
        self.__default_logger_name = None
        self.__set_config()

    def set_default_logger_level(self, logger_name, level):
        self.__default_logger_name = logger_name
        self.set_level(self.__default_logger_name, level)

    def __set_config(self, **kwargs):
        # 기본 포맷터 설정
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )

        # StreamHandler 설정 (표준 출력)
        stream_handler = logging.StreamHandler(sys.stdout)
        stream_handler.setFormatter(formatter)

        # 루트 로거에 핸들러 추가
        root_logger = logging.getLogger()
        root_logger.setLevel(logging.INFO)
        root_logger.addHandler(stream_handler)

    def set_level(self, logger_name: str, level: int):
        print('New Logger Registered :', logger_name, level)
        _logger = logging.getLogger(logger_name)
        _logger.setLevel(level)
        _logger.propagate = True

    def get_logger(self, logger_name):
        return logging.getLogger(logger_name)

    def debug(self, msg, *args, **kwargs):
        if msg is not None:
            logging.getLogger(self.__default_logger_name).debug(msg, *args, **kwargs)

    def info(self, msg, *args, **kwargs):
        if msg is not None:
            logging.getLogger(self.__default_logger_name).info(msg, *args, **kwargs)

    def warning(self, msg, *args, **kwargs):
        if msg is not None:
            logging.getLogger(self.__default_logger_name).warning(msg, *args, **kwargs)

    def error(self, msg, *args, **kwargs):
        if msg is not None:
            logging.getLogger(self.__default_logger_name).error(msg, *args, **kwargs)

    def fatal(self, msg, *args, **kwargs):
        if msg is not None:
            logging.getLogger(self.__default_logger_name).fatal(msg, *args, **kwargs)

    def exception(self, msg, *args, **kwargs):
        if msg is not None:
            logging.getLogger(self.__default_logger_name).exception(msg, *args, **kwargs)

logger = __LoggingWrapper()
