package com.ding.lesson02;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TestInsert {
    public static void main(String[] args) {

        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();
            st = conn.createStatement();
            String sql = "INSERT INTO users(id, `name`, `password`, email, birthday) " +
                    "VALUES(4, 'ding', '123456', '1023921169@qq.com', '2020-01-01')";
            int i = st.executeUpdate(sql);
            if (i > 0) {
                System.out.println("插入成功");
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, st, rs);
        }
    }
}
