package com.kzw.core.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CertUtil {

	public static Log logger = LogFactory.getLog(CertUtil.class);

	public static File get(String host, int port) {
		InputStream in=null;
		SSLSocket socket=null;
		OutputStream out =null;
		try {
			char[] passphrase = "changeit".toCharArray();
			File file = new File("jssecacerts");
			if (file.isFile() == false) {
				char SEP = File.separatorChar;
				File dir = new File(System.getProperty("java.home") + SEP
						+ "lib" + SEP + "security");
				file = new File(dir, "jssecacerts");
				if (file.isFile() == false) {
					file = new File(dir, "cacerts");
				}
			}

			
			
			
			in = new FileInputStream(file);
			KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
			ks.load(in, passphrase);
			//in.close();

			
			
			
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
			tmf.init(ks);
			X509TrustManager defaultTrustManager = (X509TrustManager) tmf.getTrustManagers()[0];
			SavingTrustManager tm = new SavingTrustManager(defaultTrustManager);
			context.init(null, new TrustManager[] { tm }, null);
			SSLSocketFactory factory = context.getSocketFactory();

			
			
			
			socket = (SSLSocket) factory.createSocket(host, port);
			
			socket.setSoTimeout(10000);
			if (socket != null) {
				socket.startHandshake();
				
				//socket.close();
			}

			X509Certificate[] chain = tm.chain;
			if (chain == null) {
				return null;
			}

			MessageDigest sha1 = MessageDigest.getInstance("SHA1");
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			for (int i = 0; i < chain.length; i++) {
				X509Certificate cert = chain[i];
				sha1.update(cert.getEncoded());
				md5.update(cert.getEncoded());
			}
			// 默认选1
			int k = 0;

			X509Certificate cert = chain[k];
			String alias = host + "-" + (k + 1);
			ks.setCertificateEntry(alias, cert);

			File cafile = new File("jssecacerts");
			out = new FileOutputStream(cafile);
			ks.store(out, passphrase);
			//out.close();

			logger.debug(">>>>   Added certificate to keystore 'jssecacerts' using alias '"+ alias + "'");
			return cafile;
		} catch (javax.net.ssl.SSLException e) {
			logger.debug("明文连接,javax.net.ssl.SSLException:" + e.getMessage());
			return null;
		} catch (KeyStoreException e) {
			e.printStackTrace();
			return null;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		} catch (CertificateException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		} catch (KeyManagementException e) {
			e.printStackTrace();
			return null;
		}finally{
			System.out.println("关闭连接...");
			try{
				if( in!=null)in.close();
				if( socket!=null)socket.close();
				if( out!=null)out.close();
			}catch (IOException e) {
				e.printStackTrace();
				System.out.println("关闭连接失败!");
			}
		}
	}

	private static final char[] HEXDIGITS = "0123456789abcdef".toCharArray();

	private static String toHexString(byte[] bytes) {
		StringBuilder sb = new StringBuilder(bytes.length * 3);
		for (int b : bytes) {
			b &= 0xff;
			sb.append(HEXDIGITS[b >> 4]);
			sb.append(HEXDIGITS[b & 15]);
			sb.append(' ');
		}
		return sb.toString();
	}

	private static class SavingTrustManager implements X509TrustManager {

		private final X509TrustManager tm;
		private X509Certificate[] chain;

		SavingTrustManager(X509TrustManager tm) {
			this.tm = tm;
		}

		public X509Certificate[] getAcceptedIssuers() {
			throw new UnsupportedOperationException();
		}

		public void checkClientTrusted(X509Certificate[] chain, String authType)
				throws CertificateException {
			throw new UnsupportedOperationException();
		}

		public void checkServerTrusted(X509Certificate[] chain, String authType)
				throws CertificateException {
			this.chain = chain;
			tm.checkServerTrusted(chain, authType);
		}
	}
	/*
	 * 
	 * //main 函数 public static void main(String[] args) { File cert=null;
	 * if(cert == null){ try { cert =
	 * CertUtil.get("smtp.qq.com",Integer.parseInt("587")); } catch (Exception
	 * e) { logger.debug(" michael create eror...."); } }
	 * 
	 * if (cert != null) {
	 * 
	 * System.setProperty("javax.net.ssl.trustStore", cert .getAbsolutePath());
	 * } logger.debug("the cert is = "+cert);
	 * 
	 * }
	 */

}
