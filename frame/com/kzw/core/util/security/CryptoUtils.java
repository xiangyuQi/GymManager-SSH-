package com.kzw.core.util.security;

import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.SecretKeySpec;

import com.kzw.core.util.EncodeUtils;
import com.kzw.core.util.ExceptionUtils;


/**
 * 支持HMAC-SHA1消息签名 及 DES/AES对称加密的工具类.
 * 
 * 支持Hex与Base64两种编码方式.
 */
public abstract class CryptoUtils {

	private static final String DES = "DES";
	private static final String AES = "AES";
	private static final String HMACSHA1 = "HmacSHA1";

	private static final int DEFAULT_HMACSHA1_KEYSIZE = 160;//RFC2401
	private static final int DEFAULT_AES_KEYSIZE = 128;
	
	/**
	 * 加密
	 * @param src 数据源
	 * @param key 密钥，长度必须是8的倍数
	 * @return	  返回加密后的数据
	 * @throws Exception
	 */
	public static byte[] encrypt(byte[] src, byte[] key) throws RuntimeException {
		//		DES算法要求有一个可信任的随机数源
		try{
			SecureRandom sr = new SecureRandom();
			// 从原始密匙数据创建DESKeySpec对象
			DESKeySpec dks = new DESKeySpec(key);
			// 创建一个密匙工厂，然后用它把DESKeySpec转换成
			// 一个SecretKey对象
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES);
			SecretKey securekey = keyFactory.generateSecret(dks);
			// Cipher对象实际完成加密操作
			Cipher cipher = Cipher.getInstance(DES);
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.ENCRYPT_MODE, securekey, sr);
			// 现在，获取数据并加密
			// 正式执行加密操作
			return cipher.doFinal(src);
		}catch(Exception e){
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 解密
	 * @param src	数据源
	 * @param key	密钥，长度必须是8的倍数
	 * @return		返回解密后的原始数据
	 * @throws Exception
	 */
	public static byte[] decrypt(byte[] src, byte[] key) throws RuntimeException {
		try{
			//		DES算法要求有一个可信任的随机数源
			SecureRandom sr = new SecureRandom();
			// 从原始密匙数据创建一个DESKeySpec对象
			DESKeySpec dks = new DESKeySpec(key);
			// 创建一个密匙工厂，然后用它把DESKeySpec对象转换成
			// 一个SecretKey对象
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES);
			SecretKey securekey = keyFactory.generateSecret(dks);
			// Cipher对象实际完成解密操作
			Cipher cipher = Cipher.getInstance(DES);
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.DECRYPT_MODE, securekey, sr);
			// 现在，获取数据并解密
			// 正式执行解密操作
			return cipher.doFinal(src);
		}catch(Exception e){
			throw new RuntimeException(e);
		}
	}
    /**
     * 数据解密
     * @param data
     * @param key 密钥
     * @return
     * @throws Exception
     */
    public final static String decrypt(String data, String key) throws Exception{
    	return new String(decrypt(hex2byte(data.getBytes()),key.getBytes()));
    }
    /**
     * 数据加密
     * @param data
     * @param key 密钥
     * @return
     * @throws Exception
     */
    public final static String encrypt(String data, String key){
    	if(data!=null)
        try {
            return byte2hex(encrypt(data.getBytes(),key.getBytes()));
        }catch(Exception e) {
			throw new RuntimeException(e);
        }
        return null;
    }

	/**
	 * 二进制转字符串
	 * @param b
	 * @return
	 */
    private static String byte2hex(byte[] b) {
		StringBuilder hs = new StringBuilder();
		String stmp;
		for (int n = 0; b!=null && n < b.length; n++) {
			stmp = Integer.toHexString(b[n] & 0XFF);
			if (stmp.length() == 1)
				hs.append('0');
			hs.append(stmp);
		}
		return hs.toString().toUpperCase();
	}
    
    private static byte[] hex2byte(byte[] b) {
        if((b.length%2)!=0)
            throw new IllegalArgumentException();
		byte[] b2 = new byte[b.length/2];
		for (int n = 0; n < b.length; n+=2) {
		    String item = new String(b,n,2);
		    b2[n/2] = (byte)Integer.parseInt(item,16);
		}
        return b2;
    }

	//-- HMAC-SHA1 funciton --//
	/**
	 * 使用HMAC-SHA1进行消息签名, 返回字节数组,长度为20字节.
	 * 
	 * @param input 原始输入字符串
	 * @param keyBytes HMAC-SHA1密钥
	 */
	public static byte[] hmacSha1(String input, byte[] keyBytes) {
		try {
			SecretKey secretKey = new SecretKeySpec(keyBytes, HMACSHA1);
			Mac mac = Mac.getInstance(HMACSHA1);
			mac.init(secretKey);
			return mac.doFinal(input.getBytes());
		} catch (GeneralSecurityException e) {
			throw ExceptionUtils.unchecked(e);
		}
	}

	/**
	 * 使用HMAC-SHA1进行消息签名, 返回Hex编码的结果,长度为40字符.
	 *	
	 * @see #hmacSha1(String, byte[])
	 */
	public static String hmacSha1ToHex(String input, byte[] keyBytes) {
		byte[] macResult = hmacSha1(input, keyBytes);
		return EncodeUtils.encodeHex(macResult);
	}

	/**
	 * 使用HMAC-SHA1进行消息签名, 返回Base64编码的结果.
	 * 
	 * @see #hmacSha1(String, byte[])
	 */
	public static String hmacSha1ToBase64(String input, byte[] keyBytes) {
		byte[] macResult = hmacSha1(input, keyBytes);
		return EncodeUtils.encodeBase64(macResult);
	}

	/**
	 * 使用HMAC-SHA1进行消息签名, 返回Base64编码的URL安全的结果.
	 * 
	 * @see #hmacSha1(String, byte[])
	 */
	public static String hmacSha1ToBase64UrlSafe(String input, byte[] keyBytes) {
		byte[] macResult = hmacSha1(input, keyBytes);
		return EncodeUtils.encodeUrlSafeBase64(macResult);
	}

	/**
	 * 校验Hex编码的HMAC-SHA1签名是否正确.
	 * 
	 * @param hexMac Hex编码的签名
	 * @param input 原始输入字符串
	 * @param keyBytes 密钥
	 */
	public static boolean isHexMacValid(String hexMac, String input, byte[] keyBytes) {
		byte[] expected = EncodeUtils.decodeHex(hexMac);
		byte[] actual = hmacSha1(input, keyBytes);

		return Arrays.equals(expected, actual);
	}

	/**
	 * 校验Base64/Base64URLSafe编码的HMAC-SHA1签名是否正确.
	 * 
	 * @param base64Mac Base64/Base64URLSafe编码的签名
	 * @param input 原始输入字符串
	 * @param keyBytes 密钥
	 */
	public static boolean isBase64MacValid(String base64Mac, String input, byte[] keyBytes) {
		byte[] expected = EncodeUtils.decodeBase64(base64Mac);
		byte[] actual = hmacSha1(input, keyBytes);

		return Arrays.equals(expected, actual);
	}

	/**
	 * 生成HMAC-SHA1密钥,返回字节数组,长度为160位(20字节).
	 * HMAC-SHA1算法对密钥无特殊要求, RFC2401建议最少长度为160位(20字节).
	 */
	public static byte[] generateMacSha1Key() {
		try {
			KeyGenerator keyGenerator = KeyGenerator.getInstance(HMACSHA1);
			keyGenerator.init(DEFAULT_HMACSHA1_KEYSIZE);
			SecretKey secretKey = keyGenerator.generateKey();
			return secretKey.getEncoded();
		} catch (GeneralSecurityException e) {
			throw ExceptionUtils.unchecked(e);
		}
	}

	/**
	 * 生成HMAC-SHA1密钥, 返回Hex编码的结果,长度为40字符. 
	 * @see #generateMacSha1Key()
	 */
	public static String generateMacSha1HexKey() {
		return EncodeUtils.encodeHex(generateMacSha1Key());
	}

	//-- DES function --//
	/**
	 * 使用DES加密原始字符串, 返回Hex编码的结果.
	 * 
	 * @param input 原始输入字符串
	 * @param keyBytes 符合DES要求的密钥
	 */
	public static String desEncryptToHex(String input, byte[] keyBytes) {
		byte[] encryptResult = des(input.getBytes(), keyBytes, Cipher.ENCRYPT_MODE);
		return EncodeUtils.encodeHex(encryptResult);
	}

	/**
	 * 使用DES加密原始字符串, 返回Base64编码的结果.
	 * 
	 * @param input 原始输入字符串
	 * @param keyBytes 符合DES要求的密钥
	 */
	public static String desEncryptToBase64(String input, byte[] keyBytes) {
		byte[] encryptResult = des(input.getBytes(), keyBytes, Cipher.ENCRYPT_MODE);
		return EncodeUtils.encodeBase64(encryptResult);
	}

	/**
	 * 使用DES解密Hex编码的加密字符串, 返回原始字符串.
	 * 
	 * @param input Hex编码的加密字符串
	 * @param keyBytes 符合DES要求的密钥
	 */
	public static String desDecryptFromHex(String input, byte[] keyBytes) {
		byte[] decryptResult = des(EncodeUtils.decodeHex(input), keyBytes, Cipher.DECRYPT_MODE);
		return new String(decryptResult);
	}

	/**
	 * 使用DES解密Base64编码的加密字符串, 返回原始字符串.
	 * 
	 * @param input Base64编码的加密字符串
	 * @param keyBytes 符合DES要求的密钥
	 */
	public static String desDecryptFromBase64(String input, byte[] keyBytes) {
		byte[] decryptResult = des(EncodeUtils.decodeBase64(input), keyBytes, Cipher.DECRYPT_MODE);
		return new String(decryptResult);
	}

	/**
	 * 使用DES加密或解密无编码的原始字节数组, 返回无编码的字节数组结果.
	 * 
	 * @param inputBytes 原始字节数组
	 * @param keyBytes 符合DES要求的密钥
	 * @param mode Cipher.ENCRYPT_MODE 或 Cipher.DECRYPT_MODE
	 */
	private static byte[] des(byte[] inputBytes, byte[] keyBytes, int mode) {
		try {
			DESKeySpec desKeySpec = new DESKeySpec(keyBytes);
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES);
			SecretKey secretKey = keyFactory.generateSecret(desKeySpec);

			Cipher cipher = Cipher.getInstance(DES);
			cipher.init(mode, secretKey);
			return cipher.doFinal(inputBytes);
		} catch (GeneralSecurityException e) {
			throw ExceptionUtils.unchecked(e);
		}
	}

	/**
	 * 生成符合DES要求的密钥, 长度为64位(8字节).
	 */
	public static byte[] generateDesKey() {
		try {
			KeyGenerator keyGenerator = KeyGenerator.getInstance(DES);
			SecretKey secretKey = keyGenerator.generateKey();
			return secretKey.getEncoded();
		} catch (GeneralSecurityException e) {
			throw ExceptionUtils.unchecked(e);
		}
	}

	/**
	 * 生成符合DES要求的Hex编码密钥, 长度为16字符.
	 */
	public static String generateDesHexKey() {
		return EncodeUtils.encodeHex(generateDesKey());
	}

	//-- AES funciton --//
	/**
	 * 使用AES加密原始字符串, 返回Hex编码的结果.
	 * 
	 * @param input 原始输入字符串
	 * @param keyBytes 符合AES要求的密钥
	 */
	public static String aesEncryptToHex(String input, byte[] keyBytes) {
		byte[] encryptResult = aes(input.getBytes(), keyBytes, Cipher.ENCRYPT_MODE);
		return EncodeUtils.encodeHex(encryptResult);
	}

	/**
	 * 使用AES加密原始字符串, 返回Base64编码的结果.
	 * 
	 * @param input 原始输入字符串
	 * @param keyBytes 符合AES要求的密钥
	 */
	public static String aesEncryptToBase64(String input, byte[] keyBytes) {
		byte[] encryptResult = aes(input.getBytes(), keyBytes, Cipher.ENCRYPT_MODE);
		return EncodeUtils.encodeBase64(encryptResult);
	}

	/**
	 * 使用AES解密Hex编码的加密字符串, 返回原始字符串.
	 * 
	 * @param input Hex编码的加密字符串
	 * @param keyBytes 符合AES要求的密钥
	 */
	public static String aesDecryptFromHex(String input, byte[] keyBytes) {
		byte[] decryptResult = aes(EncodeUtils.decodeHex(input), keyBytes, Cipher.DECRYPT_MODE);
		return new String(decryptResult);
	}

	/**
	 * 使用AES解密Base64编码的加密字符串, 返回原始字符串.
	 * 
	 * @param input Base64编码的加密字符串
	 * @param keyBytes 符合AES要求的密钥
	 */
	public static String aesDecryptFromBase64(String input, byte[] keyBytes) {
		byte[] decryptResult = aes(EncodeUtils.decodeBase64(input), keyBytes, Cipher.DECRYPT_MODE);
		return new String(decryptResult);
	}

	/**
	 * 使用AES加密或解密无编码的原始字节数组, 返回无编码的字节数组结果.
	 * 
	 * @param inputBytes 原始字节数组
	 * @param keyBytes 符合AES要求的密钥
	 * @param mode Cipher.ENCRYPT_MODE 或 Cipher.DECRYPT_MODE
	 */
	private static byte[] aes(byte[] inputBytes, byte[] keyBytes, int mode) {
		try {
			SecretKey secretKey = new SecretKeySpec(keyBytes, AES);
			Cipher cipher = Cipher.getInstance(AES);
			cipher.init(mode, secretKey);
			return cipher.doFinal(inputBytes);
		} catch (GeneralSecurityException e) {
			throw ExceptionUtils.unchecked(e);
		}
	}

	/**
	 * 生成AES密钥,返回字节数组,长度为128位(16字节).
	 */
	public static byte[] generateAesKey() {
		try {
			KeyGenerator keyGenerator = KeyGenerator.getInstance(AES);
			keyGenerator.init(DEFAULT_AES_KEYSIZE);
			SecretKey secretKey = keyGenerator.generateKey();
			return secretKey.getEncoded();
		} catch (GeneralSecurityException e) {
			throw ExceptionUtils.unchecked(e);
		}
	}

	/**
	 * 生成AES密钥, 返回Hex编码的结果,长度为32字符. 
	 * @see #generateMacSha1Key()
	 */
	public static String generateAesHexKey() {
		return EncodeUtils.encodeHex(generateAesKey());
	}
}