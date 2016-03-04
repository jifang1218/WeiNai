package com.coin.weinai.server.controllers.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.METHOD_NOT_ALLOWED, reason = "operation failure.")
public class OperationFailureException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8009250032888836902L;

}
