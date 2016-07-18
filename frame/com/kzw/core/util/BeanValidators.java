
package com.kzw.core.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import javax.validation.Validator;

import org.apache.commons.lang3.StringUtils;

/**
 * JSR303 Validator(Hibernate Validator)工具类.
 * 
 */
@SuppressWarnings("unchecked")
public class BeanValidators {

	private BeanValidators() {
	}

	/**
	 * 调用JSR303的validate方法, 验证失败时抛出ConstraintViolationException.
	 */
	public static void validateWithException(Validator validator, Object object, Class<?>... groups)
			throws ConstraintViolationException {
		Set constraintViolations = validator.validate(object, groups);
		if (!constraintViolations.isEmpty()) {
			throw new ConstraintViolationException(constraintViolations);
		}
	}

	/**
	 * 辅助方法, 转换Set<ConstraintViolation>中所有的message为字符串, 以separator分隔.
	 */
	public static String convertMessage(Set<? extends ConstraintViolation> constraintViolations, String separator) {
		if(constraintViolations!=null && constraintViolations.size() == 0) {
			return null;
		}
		List<String> errorMessages = new ArrayList<String>();
		for (ConstraintViolation violation : constraintViolations) {
			errorMessages.add(violation.getMessage());
		}
		return StringUtils.join(errorMessages.toArray(), separator);
	}

	/**
	 * 辅助方法, 转换ConstraintViolationException中的Set<ConstraintViolations>中的所有message为字符串, 以separator分隔.
	 */
	public static String convertMessage(ConstraintViolationException e, String separator) {
		return convertMessage(e.getConstraintViolations(), separator);
	}
}
