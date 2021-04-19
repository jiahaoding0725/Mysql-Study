package com.ding.lesson04;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestTransaction {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();

            // 关闭数据库的自动提交
            conn.setAutoCommit(false);

            String sql1 = "UPDATE account set money = money - 100 WHERE name = 'A'";
            pstm = conn.prepareStatement(sql1);
            pstm.executeUpdate();

//            int  x = 1/0;

            String sql2 = "UPDATE account set money = money + 100 WHERE name = 'B'";
            pstm = conn.prepareStatement(sql2);
            pstm.executeUpdate();

            // 业务完毕，提交事务
            conn.commit();
            System.out.println("成功");

        } catch (SQLException throwables) {
            try {
                // 如果失败，默认回滚
                conn.rollback(); // 如果失败，回滚事务（显示定义）
            } catch (SQLException e) {
                e.printStackTrace();
            }
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, rs);
        }
    }
}
