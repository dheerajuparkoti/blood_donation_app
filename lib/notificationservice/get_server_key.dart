import 'package:googleapis_auth/auth_io.dart';
class GetServerKey{
  Future<String> getServerKeyToken()async{
    final scopes=[
      'https://www.googleapis.com/auth/firebase.messaging',
     
    ];
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
{
  "type": "service_account",
  "project_id": "mobile-blood-bank-nepal-a2399",
  "private_key_id": "bc3a712914fd980cbd63283fa15678d6ff843246",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCqqPKHELprfDN+\nfaoTLoaZeU2603m3QZ11Hb5IAC7CXFP4xhwSWPjKGjFyhTifP3HmCqdoGeEEzeg5\ntAIR+rrCIWae3AGpBEBBtvBJIJx70ZtYhP5dML5FNWLa787OY6gt5nz5l+rkGoar\n3256RAiiqQ8AoaAOWYf4t06Kd03wtNPxqSkwxaehXNvumhItlTf9o0jXYfS4iNDp\n8mhL5drOfbFWOCDEVhciMmmqyL8kHoMQAUs2iafDgA85hh7xuw7S28zLOy/oRbtZ\n7e44iAL61zrhPQ9srtZ5Yq3qjGP6XZIyupMYZC6HSEz9PXi9/XyKeFjBpS5+3fEr\nSfMuJm6NAgMBAAECggEAJ7XHNTFpx0/vpXu1IuB9FmIY+aNym3crndBNcfCE8NnN\n+kGSz5wfS9ubbOPd4IRBSv9oo7r91oHZCvA9WRSn9zsRZ16XDk58ay4XrFRnxRHp\nXUgY7fNFGtKIzZvmWbTrsb6DjwpP8ELR2lVTniSNg9fls0ZoeV5Q2slAf8yx+JOh\nGSUHN37BBoRUOGUS4kkUi4DpEilVrYY6UCiG7Q8A8JEpNu0dfLF4HfYHP6UP3yn0\nyDkxrdx2qsQgVh1iOpiREHqZmf0hRBH+JXUWXAki2aZnnf03baPQ7QIniHRbzV32\nY8XyE52Ev9BiW8sKuLO20zqk0jvgjWFVlXXdV417CwKBgQDrHYwEkqim9+mPw9tY\nbhFwDKs3GIykYX0YGanr62Bh/RucMH5oSXKe+PW+d2gC05yubfZYpe2pdcoQmKsy\n+baEl5OIejNObucmVHovpcM4nf0VFfU9DhRfZy17zxYBQX2SAw4u2GDBMMsgnd3V\nWpt1Kw13b2fmsBjSvtVoKiRrjwKBgQC50bPlg2WGIl9qzwWdPtKo3cgfhtchK3En\ngwnXlOyuXl7nsaSpiLa3nmcHQG7rs51awNCFPoIMRFA8YqD7h/cMbyTx2us8s7oF\nByTL0y6jHgVYeiQqqDZRjdzZ5VdxLB/sR+AQ24FisGRO6OO4tmonSV4jPToAjJIV\n7JyEaUOmIwKBgQCSUhcbmXIgR1UxxYAyrn1nsFq1tS+B9bH2V7JqQlf/Y5fVQlDI\n8jzFNscpPAKdD7kIzSJs1QbtWYLhhUG2PbYbGoIUg4h+nYJ5VkWcdZrjF1+zybCP\nyL1hCkNCNATLz0gooIIpITxFvuoLaHPwHa11489Dry+IX7tzHJSPePqlfQKBgAhc\nhFDOkdHwWATRXfpOamJI4IlyotmOP+A8SEQYInJSMskQOE2cpkQq743m+1bF1U3R\nIVDtmCJ/LHEbKw1Gd/pqQepUJIOtvrAdOy2kyhNy9WCe1mPI//C5hneTl1SzXJhg\nP5fimLbdIxZd6mlUZAByj7bcOXDu4l/0LrLSncWrAoGAFoKqV+0NdO6DBuUo/m4U\naOGjgqZ8Nxn08NMV8R1cBeV3TAj59rJFT7L4HkMrkH2jubyQK4RVUzj/VSZzocV5\nxu+d+2k3ziebAktk92UWGUUUXKlBvgTmlCVbDE8R+0FX6Gka9bg8AZ0kG2+eU16E\nL1DrrnOP3pzLtZ+hB2bwFUo=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xuapx@mobile-blood-bank-nepal-a2399.iam.gserviceaccount.com",
  "client_id": "105655673998365632129",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xuapx%40mobile-blood-bank-nepal-a2399.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}



    ),
    scopes
    );
    final accessServerKey= client.credentials.accessToken.data;
    return accessServerKey;
  }
}
