/*
Navicat MySQL Data Transfer

Source Server         : MySQL
Source Server Version : 50710
Source Host           : localhost:3306
Source Database       : gym

Target Server Type    : MYSQL
Target Server Version : 50710
File Encoding         : 65001

Date: 2016-07-03 11:09:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for gym_card
-- ----------------------------
DROP TABLE IF EXISTS `gym_card`;
CREATE TABLE `gym_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `beginTime` datetime DEFAULT NULL,
  `cardNo` varchar(255) DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `dict_level` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8BD47F14E3AFEEF0` (`dict_level`),
  CONSTRAINT `FK8BD47F14E3AFEEF0` FOREIGN KEY (`dict_level`) REFERENCES `sys_dict` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gym_card
-- ----------------------------
INSERT INTO `gym_card` VALUES ('21', '2016-09-08 00:00:00', 'XJGYM0002', '2016-10-21 00:00:00', '3', '1399');
INSERT INTO `gym_card` VALUES ('22', '2016-07-04 00:00:00', '123456', '2016-07-15 00:00:00', '3', '21');
INSERT INTO `gym_card` VALUES ('23', '2016-07-03 00:00:00', '21231', '2016-07-13 00:00:00', '4', '213');
INSERT INTO `gym_card` VALUES ('24', '2016-07-25 00:00:00', '123123', '2016-07-30 00:00:00', '3', '21312');
INSERT INTO `gym_card` VALUES ('25', '2016-07-03 00:00:00', '1241245', '2016-07-08 00:00:00', '5', '231');
INSERT INTO `gym_card` VALUES ('27', '2016-07-01 00:00:00', '2315421', '2016-07-10 00:00:00', '4', '2312');
INSERT INTO `gym_card` VALUES ('28', '2016-06-30 00:00:00', '346436', '2016-07-19 00:00:00', '4', '23412');

-- ----------------------------
-- Table structure for gym_emp
-- ----------------------------
DROP TABLE IF EXISTS `gym_emp`;
CREATE TABLE `gym_emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `age` int(11) DEFAULT NULL,
  `imgUrl` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `dict_job` int(11) DEFAULT NULL,
  `dict_sex` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1D48F444D02C10E9` (`dict_job`),
  KEY `FK1D48F444D02C3192` (`dict_sex`),
  KEY `FK1D48F4444EDAE946` (`dept_id`),
  CONSTRAINT `FK1D48F4444EDAE946` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`),
  CONSTRAINT `FK1D48F444D02C10E9` FOREIGN KEY (`dict_job`) REFERENCES `sys_dict` (`id`),
  CONSTRAINT `FK1D48F444D02C3192` FOREIGN KEY (`dict_sex`) REFERENCES `sys_dict` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gym_emp
-- ----------------------------
INSERT INTO `gym_emp` VALUES ('2', '12', '/attachFiles/test/pic/201607/3e6b2e6bafb34cb793f47713d9ed7867.jpg', '张三', '8', '1', '测试', '12332412', '6');
INSERT INTO `gym_emp` VALUES ('3', '12', '/attachFiles/test/pic/201607/89c76e97d9c64ed4a37a8f59e4fe9a7a.jpg', '李四', '7', '1', '12313', '12133232', '6');
INSERT INTO `gym_emp` VALUES ('4', '48', '/attachFiles/test/pic/201607/7013b87b8d8a42769ce4a8380cc6e137.jpg', '前台', '11', '2', '123', '123', '7');
INSERT INTO `gym_emp` VALUES ('5', '12', '/attachFiles/test/pic/201607/25c81298f3f74e1cb5d82004bbbaa63c.jpg', '王二', '10', '1', '12332', '12', '6');
INSERT INTO `gym_emp` VALUES ('6', '21', '/attachFiles/test/pic/201607/dc09362f179843d493225fb0299997e5.jpg', 'lj', '7', '2', 'ht', '135', '6');
INSERT INTO `gym_emp` VALUES ('7', '20', '/attachFiles/test/pic/201607/80dba32c801641f099baee90843913c5.jpg', 'xk', '8', '2', 'ht', '150123', '7');

-- ----------------------------
-- Table structure for gym_goods
-- ----------------------------
DROP TABLE IF EXISTS `gym_goods`;
CREATE TABLE `gym_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `detail` varchar(255) DEFAULT NULL,
  `imgUrl` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `dict_category` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKEEFA13D27B74B49C` (`dict_category`),
  CONSTRAINT `FKEEFA13D27B74B49C` FOREIGN KEY (`dict_category`) REFERENCES `sys_dict` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gym_goods
-- ----------------------------
INSERT INTO `gym_goods` VALUES ('1', 'hn', '/attachFiles/test/pic/201607/0640143052574fc1893d47f0aa07a2b3.jpg', '红牛', '8', '99', '16');
INSERT INTO `gym_goods` VALUES ('2', 'jdl', '/attachFiles/test/pic/201607/e53228919ee4455fadd66b65eb55eb25.jpg', '佳得乐', '5', '99', '16');
INSERT INTO `gym_goods` VALUES ('3', '农夫山泉', '/attachFiles/test/pic/201607/4b2355bc6c124a0ea1d0b71eb461b019.jpg', '农夫山泉', '3', '99', '16');
INSERT INTO `gym_goods` VALUES ('4', 'bss', '/attachFiles/test/pic/201607/3e6e3cff72264339b782f6a45746085f.jpg', '百岁山', '6', '99', '16');
INSERT INTO `gym_goods` VALUES ('5', 'hk', '/attachFiles/test/pic/201607/cbc1dc8fa1844c4995abf9ec6dd10de7.jpg', '黑卡', '8', '99', '16');
INSERT INTO `gym_goods` VALUES ('6', 'jsst', '/attachFiles/test/pic/201607/f2bf981b364b42adbf9e3b7ecd504244.jpg', '健身手套', '45', '50', '17');
INSERT INTO `gym_goods` VALUES ('7', 'jshw', '/attachFiles/test/pic/201607/d895971632ab4a5692c02ec0e891b267.jpg', '健身护腕', '50', '50', '17');
INSERT INTO `gym_goods` VALUES ('8', 'jshx', '/attachFiles/test/pic/201607/d8c0b2547b8c4b4084ee7d946b1844d3.jpg', '健身护膝', '79', '50', '16');
INSERT INTO `gym_goods` VALUES ('9', 'gcdbf', '/attachFiles/test/pic/201607/d895971632ab4a5692c02ec0e891b267.jpg', '进口蛋白粉', '999', '20', '18');
INSERT INTO `gym_goods` VALUES ('10', 'sdfs', '/attachFiles/test/pic/201607/3867e9a1e268490cad569bc4a8ed5387.jpg', '国产蛋白粉', '699', '20', '16');
INSERT INTO `gym_goods` VALUES ('12', 'jj', '/attachFiles/test/pic/201607/3e6e3cff72264339b782f6a45746085f.jpg', '尖叫', '5.5', '99', '16');

-- ----------------------------
-- Table structure for gym_lockers
-- ----------------------------
DROP TABLE IF EXISTS `gym_lockers`;
CREATE TABLE `gym_lockers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `no` varchar(255) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `beginTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK209D7DD7594850DF` (`member_id`),
  CONSTRAINT `FK209D7DD7594850DF` FOREIGN KEY (`member_id`) REFERENCES `gym_member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=310 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gym_lockers
-- ----------------------------
INSERT INTO `gym_lockers` VALUES ('206', 'G099', '24', '2016-07-09 00:00:00', '2016-07-22 00:00:00', '11');
INSERT INTO `gym_lockers` VALUES ('208', 'G102', '49', '2016-07-01 00:00:00', '2016-09-15 00:00:00', '18');
INSERT INTO `gym_lockers` VALUES ('209', 'G100', '1232', '2016-07-03 00:00:00', '2016-07-20 00:00:00', '21');
INSERT INTO `gym_lockers` VALUES ('210', 'G104', '144', '2016-06-30 00:00:00', '2018-07-19 00:00:00', '22');
INSERT INTO `gym_lockers` VALUES ('211', 'G105', '32423', '2016-07-18 00:00:00', '2016-07-30 00:00:00', '26');
INSERT INTO `gym_lockers` VALUES ('212', 'G106', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('213', 'G107', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('214', 'G108', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('215', 'G109', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('216', 'G110', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('217', 'G111', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('218', 'G112', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('219', 'G113', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('220', 'G114', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('221', 'G115', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('222', 'G116', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('223', 'G117', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('224', 'G118', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('225', 'G119', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('226', 'G120', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('227', 'G121', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('228', 'G122', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('229', 'G123', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('230', 'G124', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('231', 'G125', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('232', 'G126', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('233', 'G127', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('234', 'G128', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('235', 'G129', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('236', 'G130', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('237', 'G131', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('238', 'G132', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('239', 'G133', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('240', 'G134', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('241', 'G135', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('242', 'G136', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('243', 'G137', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('244', 'G138', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('245', 'G139', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('246', 'G140', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('247', 'G141', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('248', 'G142', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('249', 'G143', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('250', 'G144', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('251', 'G145', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('252', 'G146', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('253', 'G147', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('254', 'G148', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('255', 'G149', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('256', 'G150', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('257', 'G151', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('258', 'G152', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('259', 'G153', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('260', 'G154', '199', '2016-09-23 00:00:00', '2018-10-26 00:00:00', '11');
INSERT INTO `gym_lockers` VALUES ('261', 'G155', '454', '2016-07-07 00:00:00', '2018-07-01 00:00:00', '11');
INSERT INTO `gym_lockers` VALUES ('262', 'G156', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('263', 'G157', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('264', 'G158', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('265', 'G159', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('266', 'G160', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('267', 'G161', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('268', 'G162', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('269', 'G163', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('270', 'G164', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('271', 'G165', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('272', 'G166', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('273', 'G167', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('274', 'G168', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('275', 'G169', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('276', 'G170', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('277', 'G171', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('278', 'G172', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('279', 'G173', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('280', 'G174', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('281', 'G175', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('282', 'G176', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('283', 'G177', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('284', 'G178', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('285', 'G179', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('286', 'G180', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('287', 'G181', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('288', 'G182', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('289', 'G183', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('290', 'G184', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('291', 'G185', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('292', 'G186', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('293', 'G187', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('294', 'G188', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('295', 'G189', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('296', 'G190', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('297', 'G191', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('298', 'G192', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('299', 'G193', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('300', 'G194', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('301', 'G195', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('302', 'G196', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('303', 'G197', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('304', 'G198', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('305', 'G199', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('306', 'G300', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('308', 'G101', null, null, null, null);
INSERT INTO `gym_lockers` VALUES ('309', 'G103', null, null, null, null);

-- ----------------------------
-- Table structure for gym_member
-- ----------------------------
DROP TABLE IF EXISTS `gym_member`;
CREATE TABLE `gym_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `age` int(11) DEFAULT NULL,
  `height` double DEFAULT NULL,
  `imgUrl` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `card_id` int(11) DEFAULT NULL,
  `coach_id` int(11) DEFAULT NULL,
  `dict_sex` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKF9F79D9ED02C3192` (`dict_sex`),
  KEY `FKF9F79D9EEFBA0A5F` (`card_id`),
  KEY `FKF9F79D9EAE82DB3` (`coach_id`),
  CONSTRAINT `FKF9F79D9EAE82DB3` FOREIGN KEY (`coach_id`) REFERENCES `gym_emp` (`id`),
  CONSTRAINT `FKF9F79D9ED02C3192` FOREIGN KEY (`dict_sex`) REFERENCES `sys_dict` (`id`),
  CONSTRAINT `FKF9F79D9EEFBA0A5F` FOREIGN KEY (`card_id`) REFERENCES `gym_card` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gym_member
-- ----------------------------
INSERT INTO `gym_member` VALUES ('11', '22', '172', '/attachFiles/test/pic/201607/7013b87b8d8a42769ce4a8380cc6e137.jpg', '漆翔宇', '135799547', '70', '28', null, '1');
INSERT INTO `gym_member` VALUES ('18', '22', '172', '/attachFiles/test/pic/201607/dda9a3eb2e8f4257b6f06d2f9a806cde.jpg', '李楷文', '158487451', '70', '21', '5', '1');
INSERT INTO `gym_member` VALUES ('21', '21', '12', '/attachFiles/test/pic/201607/dda9a3eb2e8f4257b6f06d2f9a806cde.jpg', '路威', '12412', '12', '22', '6', '1');
INSERT INTO `gym_member` VALUES ('22', '21', '21', '/attachFiles/test/pic/201607/37391b2d00eb40f0805ec2fee12822cc.jpg', '秦天明', '12124124', '21', '23', null, '1');
INSERT INTO `gym_member` VALUES ('23', '21', '21', '/attachFiles/test/pic/201607/f2bf981b364b42adbf9e3b7ecd504244.jpg', 'qtm', '123123', '12', '24', null, '1');
INSERT INTO `gym_member` VALUES ('24', '21', '21', '/attachFiles/test/pic/201607/f331bfc4e77846c699dc083ed772f346.jpg', 'lj', '21312142', '12', '25', null, '2');
INSERT INTO `gym_member` VALUES ('26', '21', '123', '/attachFiles/test/pic/201607/89c76e97d9c64ed4a37a8f59e4fe9a7a.jpg', '牛春雷', '2131421', '12', '27', '7', '1');

-- ----------------------------
-- Table structure for sys_appuser
-- ----------------------------
DROP TABLE IF EXISTS `sys_appuser`;
CREATE TABLE `sys_appuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ctime` datetime DEFAULT NULL,
  `passwd` varchar(255) DEFAULT NULL,
  `realName` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `uname` varchar(255) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `dict_sex` int(11) DEFAULT NULL,
  `roleIds` varchar(255) DEFAULT NULL,
  `roleNames` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK517CB5FA4EDAE946` (`dept_id`),
  KEY `FK517CB5FAD02C3192` (`dict_sex`),
  CONSTRAINT `FK517CB5FA4EDAE946` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`),
  CONSTRAINT `FK517CB5FAD02C3192` FOREIGN KEY (`dict_sex`) REFERENCES `sys_dict` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_appuser
-- ----------------------------
INSERT INTO `sys_appuser` VALUES ('1', '2016-07-01 18:28:56', '21232F297A57A5A743894A0E4A801FC3', '超级管理员', '0', 'admin', '7', '1', '1', '超级管理员');
INSERT INTO `sys_appuser` VALUES ('2', '2016-07-01 18:47:39', '21232F297A57A5A743894A0E4A801FC3', '漆翔宇', '0', 'qixiangyu', '7', '1', '3', '店长');
INSERT INTO `sys_appuser` VALUES ('3', '2016-07-01 18:29:11', '21232F297A57A5A743894A0E4A801FC3', '牛春雷', '0', 'niuchunlei', '7', '1', '2', '总经理');
INSERT INTO `sys_appuser` VALUES ('4', '2016-07-03 10:53:12', '81BDC8BAA3546E586A336D32426343A9', '路威', '0', 'luwei', '7', '1', '4,2,3', '前台接待，总经理，店长');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dname` varchar(255) DEFAULT NULL,
  `leaf` tinyint(1) DEFAULT NULL,
  `sn` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK74A030776D9888C1` (`parent_id`),
  CONSTRAINT `FK74A030776D9888C1` FOREIGN KEY (`parent_id`) REFERENCES `sys_dept` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES ('5', '会员服务部', '1', '1', null, '0', '');
INSERT INTO `sys_dept` VALUES ('6', '教练部', '1', '2', null, '0', '');
INSERT INTO `sys_dept` VALUES ('7', '管理部', '1', '3', null, '0', '');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemName` varchar(255) DEFAULT NULL,
  `itemValue` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `sn` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '性别', '男', null, '0');
INSERT INTO `sys_dict` VALUES ('2', '性别', '女', null, '0');
INSERT INTO `sys_dict` VALUES ('3', '会员卡', '白银会员', null, '0');
INSERT INTO `sys_dict` VALUES ('4', '会员卡', '黄金会员', null, '0');
INSERT INTO `sys_dict` VALUES ('5', '会员卡', '钻石会员', null, '0');
INSERT INTO `sys_dict` VALUES ('6', '职位', '教练主管', '', '9');
INSERT INTO `sys_dict` VALUES ('7', '职位', '形体教练', '', '2');
INSERT INTO `sys_dict` VALUES ('8', '职位', '体操教练', '', '2');
INSERT INTO `sys_dict` VALUES ('9', '职位', '体能教练', '', '2');
INSERT INTO `sys_dict` VALUES ('10', '职位', '见习教练', '', '1');
INSERT INTO `sys_dict` VALUES ('11', '职位', '前台接待', '', '0');
INSERT INTO `sys_dict` VALUES ('12', '职位', '前台经理', '', '9');
INSERT INTO `sys_dict` VALUES ('13', '职位', '会籍顾问', '', '0');
INSERT INTO `sys_dict` VALUES ('14', '职位', '总经理', '', '13');
INSERT INTO `sys_dict` VALUES ('15', '职位', '店长', '', '15');
INSERT INTO `sys_dict` VALUES ('16', '类别', '饮品', null, '0');
INSERT INTO `sys_dict` VALUES ('17', '类别', '防护用品', null, '0');
INSERT INTO `sys_dict` VALUES ('18', '类别', '营养品', null, '0');

-- ----------------------------
-- Table structure for sys_file_attach
-- ----------------------------
DROP TABLE IF EXISTS `sys_file_attach`;
CREATE TABLE `sys_file_attach` (
  `fileId` int(11) NOT NULL AUTO_INCREMENT,
  `createtime` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `delFlag` int(11) DEFAULT NULL,
  `ext` varchar(255) DEFAULT NULL,
  `fileName` varchar(255) DEFAULT NULL,
  `filePath` varchar(255) DEFAULT NULL,
  `fileType` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `totalBytes` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`fileId`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_file_attach
-- ----------------------------
INSERT INTO `sys_file_attach` VALUES ('19', '2016-07-03 10:22:30', null, '1', '0', 'jpg', '120404160621-4.jpg', '/test/pic/201607/0e86296f15314ff6b333138ee438b2e3.jpg', null, '482.5 KB', '482526');
INSERT INTO `sys_file_attach` VALUES ('20', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '120404160621-8.jpg', '/test/pic/201607/db8787d2312248fdbe663d41a5578103.jpg', null, '245.4 KB', '245387');
INSERT INTO `sys_file_attach` VALUES ('21', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '120404160621-6.jpg', '/test/pic/201607/dda9a3eb2e8f4257b6f06d2f9a806cde.jpg', null, '968.8 KB', '968777');
INSERT INTO `sys_file_attach` VALUES ('22', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '139459071549.jpg', '/test/pic/201607/7013b87b8d8a42769ce4a8380cc6e137.jpg', null, '432.4 KB', '432444');
INSERT INTO `sys_file_attach` VALUES ('23', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '120404160621-3.jpg', '/test/pic/201607/080449dcf67d4a6ea6bfa38a36d0212f.jpg', null, '1.15 MB', '1150055');
INSERT INTO `sys_file_attach` VALUES ('24', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '1356484329180.jpg', '/test/pic/201607/89c76e97d9c64ed4a37a8f59e4fe9a7a.jpg', null, '107.6 KB', '107636');
INSERT INTO `sys_file_attach` VALUES ('25', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '120404160621-0.jpg', '/test/pic/201607/80dba32c801641f099baee90843913c5.jpg', null, '810.4 KB', '810412');
INSERT INTO `sys_file_attach` VALUES ('26', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '1459218674619.jpg', '/test/pic/201607/25c81298f3f74e1cb5d82004bbbaa63c.jpg', null, '247.3 KB', '247298');
INSERT INTO `sys_file_attach` VALUES ('27', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '1459218731747.jpg', '/test/pic/201607/37391b2d00eb40f0805ec2fee12822cc.jpg', null, '91.3 KB', '91322');
INSERT INTO `sys_file_attach` VALUES ('28', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '1459218698546.jpg', '/test/pic/201607/bd2247264b0f4f54a3554403babc43b2.jpg', null, '347.5 KB', '347502');
INSERT INTO `sys_file_attach` VALUES ('29', '2016-07-03 10:22:31', null, '1', '0', 'jpg', '1459218742882.jpg', '/test/pic/201607/3e6b2e6bafb34cb793f47713d9ed7867.jpg', null, '62.5 KB', '62494');
INSERT INTO `sys_file_attach` VALUES ('30', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1459218751410.jpg', '/test/pic/201607/05c8202fea7d4b43b098669fa113b0c5.jpg', null, '164.4 KB', '164394');
INSERT INTO `sys_file_attach` VALUES ('31', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1459218758819.jpg', '/test/pic/201607/ba1a150ac255434b90bd9353765d87fc.jpg', null, '211.3 KB', '211275');
INSERT INTO `sys_file_attach` VALUES ('32', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1459218780944.jpg', '/test/pic/201607/a4148f8980da459fab8492386f2e3c80.jpg', null, '141.0 KB', '140976');
INSERT INTO `sys_file_attach` VALUES ('33', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1459218770717.jpg', '/test/pic/201607/4c55f17408cc4172942462828b636562.jpg', null, '218.5 KB', '218473');
INSERT INTO `sys_file_attach` VALUES ('34', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1424832733998.jpg', '/test/pic/201607/9dd2abf82bc7455ea9516fdce91981b2.jpg', null, '907.1 KB', '907102');
INSERT INTO `sys_file_attach` VALUES ('35', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1420598946304.jpg', '/test/pic/201607/dc09362f179843d493225fb0299997e5.jpg', null, '747.7 KB', '747730');
INSERT INTO `sys_file_attach` VALUES ('36', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1459218793696.jpg', '/test/pic/201607/427ef65087ad404388691df75199a79e.jpg', null, '235.9 KB', '235944');
INSERT INTO `sys_file_attach` VALUES ('37', '2016-07-03 10:22:32', null, '1', '0', 'jpg', '1459218807800.jpg', '/test/pic/201607/d87a6591fa974b198bea6baa67bb154f.jpg', null, '237.9 KB', '237862');
INSERT INTO `sys_file_attach` VALUES ('38', '2016-07-03 10:30:33', null, '1', '0', 'jpg', 'ChMkJ1begQSICogEAAlihJFQRbgAAM7vQOyjrkACWKc429.jpg', '/test/pic/201607/9b3cff58c8b14740b25f8cee5f2933ce.jpg', null, '165.1 KB', '165078');

-- ----------------------------
-- Table structure for sys_global_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_global_type`;
CREATE TABLE `sys_global_type` (
  `proTypeId` int(11) NOT NULL AUTO_INCREMENT,
  `catKey` varchar(255) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `nodeKey` varchar(255) DEFAULT NULL,
  `parentId` int(11) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `sn` int(11) DEFAULT NULL,
  `typeName` varchar(255) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`proTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_global_type
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iconCls` varchar(255) DEFAULT NULL,
  `leaf` tinyint(1) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sn` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK74A44791D034FE0E` (`parent_id`),
  CONSTRAINT `FK74A44791D034FE0E` FOREIGN KEY (`parent_id`) REFERENCES `sys_menu` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', 'glyphicon glyphicon-user', '0', '0', '会员信息管理', '0', 'member/view', null);
INSERT INTO `sys_menu` VALUES ('2', 'glyphicon glyphicon-align-justify', '0', '0', '系统管理', '5', '#', null);
INSERT INTO `sys_menu` VALUES ('3', 'glyphicon glyphicon-align-justify', '1', '1', '菜单管理', '0', 'menu/view', '2');
INSERT INTO `sys_menu` VALUES ('4', 'glyphicon glyphicon-pause', '1', '1', '部门管理', '1', 'dept/view', '2');
INSERT INTO `sys_menu` VALUES ('5', 'glyphicon glyphicon-user', '1', '1', '角色管理', '2', 'role/view', '2');
INSERT INTO `sys_menu` VALUES ('6', 'glyphicon glyphicon-tower', '1', '1', '用户管理', '3', 'user/view', '2');
INSERT INTO `sys_menu` VALUES ('8', 'glyphicon glyphicon-folder-close', '1', '1', '基本信息管理', '0', 'member/view', '1');
INSERT INTO `sys_menu` VALUES ('9', 'glyphicon glyphicon-copyright-mark', '1', '1', '私人教练管理', '2', 'emp/coach_view', '1');
INSERT INTO `sys_menu` VALUES ('10', 'glyphicon glyphicon-asterisk', '1', '1', '数据字典管理', '4', 'dict/view', '2');
INSERT INTO `sys_menu` VALUES ('14', 'glyphicon glyphicon-user', '1', '0', '员工信息管理', '1', 'emp/view', null);
INSERT INTO `sys_menu` VALUES ('15', 'glyphicon glyphicon-home', '1', '1', '会员租柜管理', '3', 'lockers/view', '1');
INSERT INTO `sys_menu` VALUES ('16', 'glyphicon glyphicon-book', '1', '1', '会员卡管理', '1', 'card/view', '1');
INSERT INTO `sys_menu` VALUES ('17', 'glyphicon glyphicon-cutlery', '1', '0', '商品库存管理', '4', 'goods/view', null);
INSERT INTO `sys_menu` VALUES ('18', 'glyphicon glyphicon-briefcase', '1', '1', '附件上传管理', '5', 'fileAttach/view', '2');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menuIds` varchar(255) DEFAULT NULL,
  `menuNames` varchar(1000) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '_ALL', '系统管理,菜单管理,部门管理,会员信息管理,员工信息管理', '超级管理员', '拥有所有权限');
INSERT INTO `sys_role` VALUES ('2', '1,8,16,9,15,14', '会员信息管理, 基本信息管理, 会员卡管理, 私人教练管理, 会员租柜管理, 员工信息管理', '总经理', '管理会员信息和员工信息');
INSERT INTO `sys_role` VALUES ('3', '1,8,16,9,15,14,2,4,6', '会员信息管理, 基本信息管理, 会员卡管理, 私人教练管理, 会员租柜管理, 员工信息管理, 系统管理, 部门管理, 用户管理', '店长', '管理会员信息,员工信息,以及部门和用户的管理');
INSERT INTO `sys_role` VALUES ('4', '1,8,16,9,15', '会员信息管理, 基本信息管理, 会员卡管理, 私人教练管理, 会员租柜管理', '前台接待', '管理会员信息');
