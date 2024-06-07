package control;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.RequestContext;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import model.ProductBean;
import model.ProductModel;

/**
 * Servlet implementation class Vendita
 */
@WebServlet("/Vendita")
public class Vendita extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Vendita() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductBean product = new ProductBean();
        product.setEmail((String) request.getSession().getAttribute("email"));
        
         String UPLOAD_DIRECTORY = request.getServletContext().getRealPath("/") + "img/productIMG/";
            //process only if its multipart content
            if(ServletFileUpload.isMultipartContent(request)) {
                try {
                    List<FileItem> multiparts = new ServletFileUpload(
                                             new DiskFileItemFactory()).parseRequest(new ServletRequestContext(request));

                    for(FileItem item : multiparts){
                        if(!item.isFormField()){
                            String name = new File(item.getName()).getName();
                            item.write(new File(UPLOAD_DIRECTORY + File.separator + name));
                            product.setImmagine(name);
                        }
                        else {
                            if (item.getFieldName().compareTo("nome") == 0) {
                                product.setNome(item.getString());
                            }
                            else if (item.getFieldName().compareTo("prezzo") == 0) {
                                double prezzo = parseDoubleWithDefault(item.getString(), -1);
                                if (prezzo < 0) {
                                    // Il prezzo non è valido, interrompi l'elaborazione e reindirizza alla pagina di errore
                                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                                    return;
                                }
                                product.setPrezzo(prezzo);
                            }
                            else if (item.getFieldName().compareTo("spedizione") == 0) {
                                double spedizione = parseDoubleWithDefault(item.getString(), -1);
                                if (spedizione < 0) {
                                    // Le spese di spedizione non sono valide, interrompi l'elaborazione e reindirizza alla pagina di errore
                                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                                    return;
                                }
                                product.setSpedizione(spedizione);
                            }
                            else if (item.getFieldName().compareTo("tipologia") == 0) {
                                product.setTipologia(item.getString());
                            }
                            else if (item.getFieldName().compareTo("tag") == 0) {
                                product.setTag(item.getString());
                            }
                            else if (item.getFieldName().compareTo("descrizione") == 0) {
                                product.setDescrizione(item.getString());
                            }
                        }
                    }

                   //File uploaded successfully
                   request.setAttribute("message", "File Uploaded Successfully");
                   
                } catch (Exception ex) {
                    // Gestione delle eccezioni
                    ex.printStackTrace();
                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                    return;
                }          

            }
            else {
                request.setAttribute("message", "Sorry this Servlet only handles file upload request");
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                return;
            }
            
            // Salvataggio del prodotto nel database
            ProductModel model = new ProductModel();
            try {
                model.doSave(product);
            } catch (SQLException e) {
                // Gestione delle eccezioni
                e.printStackTrace();
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                return;
            }
            
            request.getSession().setAttribute("refreshProduct", true);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
            

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chiamata a doGet per gestire sia le richieste GET che POST
        doGet(request, response);
    }
    
    // Metodo per il parsing di un double con valore di default in caso di errore
    private double parseDoubleWithDefault(String value, double defaultValue) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
