package com.board.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

public class JDBCTest {

	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testConnection() {
		try(Connection con =
				DriverManager.getConnection(
						"jdbc:oracle:thin:@127.0.0.1:1521:XE",
						"system",
						"1234")){
			System.out.println(con);
			System.out.println("DB연결성공");
		} catch(Exception e) {
			fail(e.getMessage());
		}
	}
}
