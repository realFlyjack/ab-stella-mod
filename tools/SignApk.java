import com.android.apksig.ApkSigner;

import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.X509Certificate;
import java.util.Collections;

public final class SignApk {
    public static void main(String[] args) throws Exception {
        Path input = Paths.get(args[0]);
        Path output = Paths.get(args[1]);
        char[] password = args[2].toCharArray();

        KeyStore keyStore = KeyStore.getInstance("JKS");
        try (FileInputStream stream = new FileInputStream(args[3])) {
            keyStore.load(stream, password);
        }

        PrivateKey privateKey = (PrivateKey) keyStore.getKey(args[4], password);
        X509Certificate certificate =
                (X509Certificate) keyStore.getCertificate(args[4]);
        ApkSigner.SignerConfig signer =
                new ApkSigner.SignerConfig.Builder(
                                args[4], privateKey, Collections.singletonList(certificate))
                        .build();

        ApkSigner apkSigner =
                new ApkSigner.Builder(Collections.singletonList(signer))
                        .setInputApk(input.toFile())
                        .setOutputApk(output.toFile())
                        .setV1SigningEnabled(true)
                        .setV2SigningEnabled(true)
                        .build();
        apkSigner.sign();
    }
}
