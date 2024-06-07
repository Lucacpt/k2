package control;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ClickjackingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Puoi aggiungere qui il codice di inizializzazione, se necessario
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpServletResponse = (HttpServletResponse) response;
            httpServletResponse.setHeader("X-Frame-Options", "DENY"); // oppure SAMEORIGIN, ALLOW-FROM uri
            // oppure
            // httpServletResponse.setHeader("Content-Security-Policy", "frame-ancestors 'self'");
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Puoi aggiungere qui il codice di distruzione, se necessario
    }
}
