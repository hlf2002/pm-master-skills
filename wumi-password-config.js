/**
 * 天下无密主密码配置文件
 *
 * 加密方式: XOR(0x5A) 后 Base64 编码
 * 解密算法: Base64 解码后 XOR(0x5A)
 */

// 加密后的主密码 (XOR 0x5A + Base64)
const ENCRYPTED_MASTER_PASSWORD = 'MTBoaW5uMDJuaWs=';

/**
 * 解密天下无密主密码
 * @returns {string} 解密后的明文密码
 */
function decryptMasterPassword() {
  try {
    const buffer = Buffer.from(ENCRYPTED_MASTER_PASSWORD, 'base64');
    const decrypted = buffer.map(b => b ^ 0x5A).toString();
    return decrypted;
  } catch (error) {
    console.error('解密失败:', error.message);
    return null;
  }
}

/**
 * 加密明文密码 (用于添加新密码到配置)
 * @param {string} plaintext - 明文密码
 * @returns {string} 加密后的 Base64 字符串
 */
function encryptPassword(plaintext) {
  const buffer = Buffer.from(plaintext);
  const encrypted = buffer.map(b => b ^ 0x5A).toString('base64');
  return encrypted;
}

// 导出
module.exports = {
  ENCRYPTED_MASTER_PASSWORD,
  decryptMasterPassword,
  encryptPassword
};

// 调试: 运行 node wumi-password-config.js 可测试加解密
if (require.main === module) {
  console.log('加密后:', ENCRYPTED_MASTER_PASSWORD);
  console.log('解密后:', decryptMasterPassword());
}
