package com.ding.lesson05;

import com.ding.lesson02.util.JdbcUtils;
import com.ding.lesson05.utils.JdbcUtilsC3P0;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestC3P0 {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtilsC3P0.getConnection();

            String sql = "SELECT * FROM users WHERE `name` = ? AND `password` = ?";
            pstm = conn.prepareStatement(sql);

            pstm.setString(1, "lisi");
            pstm.setString(2, "123456");

            rs = pstm.executeQuery();
            while (rs.next()) {
                System.out.println(rs.getString("name"));
                System.out.println(rs.getString("password"));
                System.out.println(rs.getString("email"));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtilsC3P0.release(conn, pstm, rs);
        }
    }
}
