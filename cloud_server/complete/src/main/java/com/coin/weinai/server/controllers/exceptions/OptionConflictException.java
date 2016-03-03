package com.coin.weinai.server.controllers.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.CONFLICT, reason = "The option conflicts with the one in database.")
public class OptionConflictException extends RuntimeException {

	private static final long serialVersionUID = 435250945115607045L;

}
