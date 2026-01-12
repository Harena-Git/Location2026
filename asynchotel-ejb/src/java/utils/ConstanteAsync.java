package utils;

import annexe.ProduitLib;
import chatbot.ClassIA;
import fabrication.FabricationFilleCpl2;
import faturefournisseur.FactureFournisseurDetailsCpl;
import prevision.PrevisionComplet;
import vente.VenteDetailsLib;

public class ConstanteAsync {
    public static Class<? extends ClassIA>[] iaClasses = new Class[]{VenteDetailsLib.class, FactureFournisseurDetailsCpl.class, FabricationFilleCpl2.class, PrevisionComplet.class, ProduitLib.class};
    public static final String API_KEY = "AIzaSyBp79rk0qe1FEPYeKPx6TuORYABQrV2c4I";
    public static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + API_KEY;
}
