from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import serialization
import base64

def generate_vapid_keys():
    private_key = ec.generate_private_key(ec.SECP256R1())
    public_key = private_key.public_key()

    # 🔹 비공개 키 (PRIVATE KEY)
    private_der = private_key.private_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption(),
    )

    # 🔹 공개 키 (PUBLIC KEY)
    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.X962,
        format=serialization.PublicFormat.UncompressedPoint,
    )

    # 🔹 Base64 URL 인코딩 (패딩 제거)
    private_key_b64 = base64.urlsafe_b64encode(private_der).decode("utf-8")
    public_key_b64 = base64.urlsafe_b64encode(public_pem).decode("utf-8")

    return public_key_b64, private_key_b64

# ✅ VAPID 키 생성
public_key, private_key = generate_vapid_keys()
print(public_key)
print("\n")
print(private_key)

# import base64

#key_b64 = "LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JR0hBZ0VBTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEJHMHdhd0lCQVFRZ0kvMEVqQ2pHbXVUTkF6Z2MKTmRtM0FVS0ZKTjE0Uk5HV3Z2clZPNFVlVDBpaFJBTkNBQVNIRHcvL3pmTFQrL0M3T3BtSU5CYjJmaHhFNXhzOQp1SjJOdkhlcGRaLytYV3JQSlBtQ2J2OU1ZaGhYUjhWV2JGcHFHK0JOM0huU3VOaDlIQ1FQTmRYbQotLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tCg"
decoded = base64.urlsafe_b64decode(private_key)
print(decoded)


# public BKw0ZV97Ta6tYqqC_NQibC2qBNfr8O4GPF3ZmZfOf0TApfGe38w5-Q9u8SOWMxdtDKeTad9k33tJUAYzjEZYx6k
# private LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JR0hBZ0VBTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEJHMHdhd0lCQVFRZ1lsTUVNek9kdFhLU0hsdHIKSkJMODZtR2JQOUs3UUVOcmcrNkN6UFdTZnd5aFJBTkNBQVNzTkdWZmUwMnVyV0txZ3Z6VUltd3RxZ1RYNi9EdQpCanhkMlptWHpuOUV3S1h4bnQvTU9ma1BidkVqbGpNWGJReW5rMm5mWk45N1NWQUdNNHhHV01lcAotLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tCg