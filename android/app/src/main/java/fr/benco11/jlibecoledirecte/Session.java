package fr.benco11.jlibecoledirecte;

import android.os.Build;

import androidx.annotation.RequiresApi;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

import javax.annotation.Nullable;

import com.google.gson.Gson;

import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteAccountTypeException;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteIOException;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteLoginException;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirectePeriodeException;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteUnknownConnectionException;
import fr.benco11.jlibecoledirecte.login.Account;
import fr.benco11.jlibecoledirecte.login.LoginJson;
import fr.benco11.jlibecoledirecte.student.*;
import fr.benco11.jlibecoledirecte.utils.HttpUtils;
import io.flutter.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@RequiresApi(api = Build.VERSION_CODES.N)
public class Session {
	
	public static final String ECOLEDIRECTE_STUDENTS_SECTION_URL = "https://api.ecoledirecte.com/v3/eleves/";
	public static final String ECOLEDIRECTE_STUDENTS_NOTEGET_URL = "/notes.awp?verbe=get&";
	public static final String ECOLEDIRECTE_JSON_DATA_START_TOKEN = "data={\"token\": \"";
	
	private String pass;
	private String username;
	
	private String token;
	private int id;
	private int idLogin;
	
	private Account account;
	
	/**
	 * 
	 * @param username identifiant de l'utilisateur
	 * @param pass mot de passe de l'utilisateur
	 */

	public Session(String username, String pass) {
		this.username = username;
		this.pass = pass;
	}
	
	/**
	 * 
	 * Connecte la session et remplie avec les champs <code>pass</code> et <code>username</code>, les champs <code>token</code>, <code>id</code>, <code>idLogin</code> et <code>account</code>
	 * @return <code>1</code> si la requête s'est bien effectuée sinon <code>-1</code> si une erreur réseau s'est produite
	 * @throws EcoleDirecteLoginException une erreur lors de la connexion s'est produite
	 */
	
	public int connect() throws EcoleDirecteLoginException {
		try {
			String r = HttpUtils.sendRequest("https://api.ecoledirecte.com/v3/login.awp", "data={\"identifiant\": \"" + username + "\", \"motdepasse\": \"" + pass + "\"}", "POST", true, true);
			LoginJson loginJson = new Gson().fromJson(r, LoginJson.class);
			if(loginJson.getCode() != 200) {
				throw new EcoleDirecteLoginException(loginJson.getMessage());
			}
			
			token = loginJson.getToken();
			account = loginJson.getLoginData().getAccount();
			id = account.getId();
			idLogin = account.getIdLogin();
			return 1;
		} catch (IOException e) {
			e.printStackTrace();
			return -1;
		}
	}

	/**
	 * Renvoie un objet de type <code>Account</code>
	 * @return l'objet de type <code>Account</code> qui représente le compte de l'utilisateur
	 */
	
	public Account getAccount() {
		return account;
	}
	
	/**
	 * Renvoie l'identifiant
	 * @return l'identifiant de la session
	 */

	public String getUsername() {
		return username;
	}

	/**
	 * Renvoie le token
	 * @return le token de la session
	 */
	
	public String getToken() {
		return token;
	}
	
	/**
	 * Renvoie l'id
	 * @return l'id de la session
	 */
	
	public int getId() {
		return id;
	}

	/**
	 * Renvoie le idLogin
	 * @return le idlogin de la session
	 */
	
	public int getIdLogin() {
		return idLogin;
	}
	
	/**
	 * Récupère la liste des moyennes de chaque matière parmis tous les trimestres
	 * @return la liste de toutes les moyennes de chaque matière dans tous les trimestres
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 */
	
	public List<Grade> getAverageGrades() throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson gradeJson = new Gson().fromJson(r, GradeJson.class);
			if(gradeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			ArrayList<Grade> averageGradesList = new ArrayList<>();
			gradeJson.getData().getPeriodes().forEach(e -> e.getEnsembleMatieres().getDisciplines().forEach(a -> {
					if(a.getAverage().length() > 0)
						averageGradesList.add(new Grade(a.getAverage(), a.getCoef(), a.getId()));
				}
			));
			return averageGradesList;
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Récupère la liste des moyennes d'un trimestre
	 * @param periode le numéro du trimestre voulu
	 * @return la liste de toutes les moyennes de chaque matière dans le trimestre n°<code>periode</code>
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 * @throws EcoleDirectePeriodeException le trimestre n'a pas été trouvé
	 */
	
	public List<Grade> getAverageGrades(int periode) throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException, EcoleDirectePeriodeException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson gradeJson = new Gson().fromJson(r, GradeJson.class);
			if(gradeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			ArrayList<Grade> averageGradesList = new ArrayList<>();
			
			Optional<GradePeriode> opPeriode = gradeJson.getData().getPeriodes().stream().filter(e -> e.getCodePeriode().equalsIgnoreCase("A00" + periode)).findFirst();
			if(!opPeriode.isPresent())
				throw new EcoleDirectePeriodeException();
			opPeriode.get().getEnsembleMatieres().getDisciplines().forEach(e -> {
				if(e.getAverage().length() > 0)
					averageGradesList.add(new Grade(e.getAverage(), e.getCoef(), e.getId()));
			});
			return averageGradesList;
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Récupère la liste des moyennes minimum de chaque matière parmis tous les trimestres
	 * @return la liste de toutes les moyennes minimum de chaque matière dans tous les trimestres
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 */
	
	public List<Grade> getMinAverageGrades() throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson gradeJson = new Gson().fromJson(r, GradeJson.class);
			if(gradeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			ArrayList<Grade> averageGradesList = new ArrayList<>();
			gradeJson.getData().getPeriodes().forEach(e -> e.getEnsembleMatieres().getDisciplines().forEach(a -> {
					if(a.getMinAverage().length() > 0)
						averageGradesList.add(new Grade(a.getMinAverage(), a.getCoef(), a.getId()));
				}
			));
			return averageGradesList;
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Récupère la liste des moins bonnes moyennes d'un trimestre
	 * @param periode le numéro du trimestre voulu
	 * @return la liste de toutes les moyennes minimum de chaque matière dans le trimestre n°<code>periode</code>
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 * @throws EcoleDirectePeriodeException le trimestre n'a pas été trouvé
	 */

	public List<Grade> getMinAverageGrades(int periode) throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException, EcoleDirectePeriodeException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson gradeJson = new Gson().fromJson(r, GradeJson.class);
			if(gradeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			ArrayList<Grade> averageGradesList = new ArrayList<>();

			Optional<GradePeriode> opPeriode = null;
			if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
				opPeriode = gradeJson.getData().getPeriodes().stream().filter(e -> e.getCodePeriode().equalsIgnoreCase("A00" + periode)).findFirst();
			}
			if(!opPeriode.isPresent())
				throw new EcoleDirectePeriodeException();
			
			opPeriode.get().getEnsembleMatieres().getDisciplines().forEach(e -> {
				if(e.getMinAverage().length() > 0)
					averageGradesList.add(new Grade(e.getMinAverage(), e.getCoef(), e.getId()));
			});
			return averageGradesList;
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}

	public String getEmploiDuTemps() throws EcoleDirecteUnknownConnectionException {
		if(!account.getTypeCompte().equals("E")) throw new EcoleDirecteUnknownConnectionException();

		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm");
			JSONObject item = new JSONObject();
			item.put("dateDebut", formatter.format(Calendar.getInstance().getTime()));
			item.put("dateFin", formatter.format(Calendar.getInstance().getTime()));
			item.put("token", token);


			String request = HttpUtils.sendRequest("https://api.ecoledirecte.com/v3/E/" +
					this.id +
					"/emploidutemps.awp?verbe=get&", "data=" + item.toString(), "POST", true, true);

			JSONObject obj = new JSONObject(request);

			JSONArray arr = obj.getJSONArray("data");

			return arr.toString();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return "";
	}

	public String getEmploiDuTempsOn(String date) throws EcoleDirecteUnknownConnectionException {
		if(!account.getTypeCompte().equals("E")) throw new EcoleDirecteUnknownConnectionException();

		try {
			JSONObject item = new JSONObject();
			item.put("dateDebut", date);
			item.put("dateFin", date);
			item.put("token", token);

			String request = HttpUtils.sendRequest("https://api.ecoledirecte.com/v3/E/" +
					this.id +
					"/emploidutemps.awp?verbe=get&", "data=" + item.toString(), "POST", true, true);

			JSONObject obj = new JSONObject(request);

			JSONArray arr = obj.getJSONArray("data");

			return arr.toString();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return "";
	}

	public List<Cours> getEmploiDuTempsUntilDate(String date) throws EcoleDirecteUnknownConnectionException {
		if(!account.getTypeCompte().equals("E")) throw new EcoleDirecteUnknownConnectionException();

		List<Cours> allCours = new ArrayList<>();

		try {
			SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
			JSONObject item = new JSONObject();
			item.put("dateDebut", formatter2.format(Calendar.getInstance().getTime()));
			item.put("dateFin", date);
			item.put("token", token);


			String request = HttpUtils.sendRequest("https://api.ecoledirecte.com/v3/E/" +
					this.id +
					"/emploidutemps.awp?verbe=get&", "data=" + item.toString(), "POST", true, true);

			JSONObject obj = new JSONObject(request);

			JSONArray arr = obj.getJSONArray("data");

			for (int i = 0; i < arr.length(); i++)
			{
				Cours cours = new Cours(
						arr.getJSONObject(i).getString("start_date"),
						arr.getJSONObject(i).getString("end_date"),
						arr.getJSONObject(i).getString("classe"),
						arr.getJSONObject(i).getString("classeCode"),
						arr.getJSONObject(i).getString("prof"),
						arr.getJSONObject(i).getString("matiere"),
						arr.getJSONObject(i).getString("salle"),
						arr.getJSONObject(i).getString("codeMatiere"),
						arr.getJSONObject(i).getString("typeCours"),
						arr.getJSONObject(i).getString("icone"),
						arr.getJSONObject(i).getString("text"),
						arr.getJSONObject(i).getString("groupe"),
						arr.getJSONObject(i).getString("groupeCode"),
						arr.getJSONObject(i).getBoolean("dispensable"),
						arr.getJSONObject(i).getBoolean("isFlexible"),
						arr.getJSONObject(i).getBoolean("isAnnule"),
						arr.getJSONObject(i).getBoolean("isModifie"),
						arr.getJSONObject(i).getBoolean("contenuDeSeance"),
						arr.getJSONObject(i).getBoolean("devoirAFaire"),
						arr.getJSONObject(i).getInt("dispense"),
						arr.getJSONObject(i).getInt("classeId"),
						arr.getJSONObject(i).getInt("groupeId")
				);

				allCours.add(cours);
				System.out.println(allCours.size());
			}

		} catch (IOException | ParseException | JSONException e) {
			e.printStackTrace();
		}

		return allCours;
	}
	
	/**
	 * Récupère la liste des moyennes maximum de chaque matière parmis tous les trimestres
	 * @return la liste de toutes les moyennes maximum de chaque matière dans tous les trimestres
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 */
	
	public List<Grade> getMaxAverageGrades() throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson gradeJson = new Gson().fromJson(r, GradeJson.class);
			if(gradeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			ArrayList<Grade> averageGradesList = new ArrayList<>();
			gradeJson.getData().getPeriodes().forEach(e -> e.getEnsembleMatieres().getDisciplines().forEach(a -> {
					if(a.getMaxAverage().length() > 0)
						averageGradesList.add(new Grade(a.getMaxAverage(), a.getCoef(), a.getId()));
				}
			));
			return averageGradesList;
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Récupère la liste des meilleures moyennes d'un trimestre
	 * @param periode le numéro du trimestre voulu
	 * @return la liste de toutes les moyennes maximum de chaque matière dans le trimestre n°<code>periode</code>
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirectePeriodeException le trimestre n'a pas été trouvé
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 */
	
	public List<Grade> getMaxAverageGrades(int periode) throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirectePeriodeException, EcoleDirecteIOException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson gradeJson = new Gson().fromJson(r, GradeJson.class);
			if(gradeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			ArrayList<Grade> averageGradesList = new ArrayList<>();
			
			Optional<GradePeriode> optional = gradeJson.getData().getPeriodes().stream().filter(e -> e.getCodePeriode().equalsIgnoreCase("A00" + periode)).findFirst();
			
			if(!optional.isPresent())
				throw new EcoleDirectePeriodeException();
			
			optional.get().getEnsembleMatieres().getDisciplines().forEach(e -> {
				if(e.getMaxAverage().length() > 0)
					averageGradesList.add(new Grade(e.getMaxAverage(), e.getCoef(), e.getId()));
			});
			return averageGradesList;
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Récupère l'ensemble des matières d'un trimestre
	 * @param periode le numéro du trimestre voulu
	 * @return la liste des matières dans le trimestre numéro <code>periode</code>
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 * @throws EcoleDirectePeriodeException le trimestre n'a pas pû être trouvé
	 */
	
	public List<GradeDiscipline> getDisciplines(int periode) throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException, EcoleDirectePeriodeException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson disciplineJson = new Gson().fromJson(r, GradeJson.class);
			if(disciplineJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			Optional<GradePeriode> optional = disciplineJson.getData().getPeriodes().stream().filter(e -> e.getCodePeriode().equals("A00" + periode)).findFirst();
			if(!optional.isPresent())
				throw new EcoleDirectePeriodeException();
			
			return optional.get().getEnsembleMatieres().getDisciplines().stream().collect(Collectors.toList());
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Renvoie la liste des trimestres
	 * @return la liste des trimestres
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 */
	
	public List<GradePeriode> getPeriodes() throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson disciplineJson = new Gson().fromJson(r, GradeJson.class);
			if(disciplineJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			Object[] periodes = disciplineJson.getData().getPeriodes().toArray();
			return Arrays.asList(Arrays.copyOf(periodes, periodes.length, GradePeriode[].class));
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Renvoie un trimestre
	 * @param periode numéro du trimestre
	 * @return un trimestre
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 * @throws EcoleDirectePeriodeException le trimestre n'a pas pû être trouvé
	 */
	public GradePeriode getPeriode(int periode) throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException, EcoleDirectePeriodeException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + ECOLEDIRECTE_STUDENTS_NOTEGET_URL, ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			GradeJson disciplineJson = new Gson().fromJson(r, GradeJson.class);
			if(disciplineJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			
			Object[] periodes = disciplineJson.getData().getPeriodes().toArray();
			return Arrays.asList(Arrays.copyOf(periodes, periodes.length, GradePeriode[].class)).stream().filter(e -> e.getCodePeriode().equals("A00" + periode)).findFirst().orElseThrow(EcoleDirectePeriodeException::new);
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
	
	/**
	 * Renvoie les données de la vie scolaire
	 * @return l'objet de type <code>SchoolLifeData</code> correspondant aux données de la vie scolaire
	 * @throws EcoleDirecteAccountTypeException le compte utilisé n'est pas un compte élève
	 * @throws EcoleDirecteUnknownConnectionException une erreur inconnue a eu lieu
	 * @throws EcoleDirecteIOException une erreur réseau a eu lieu
	 */
	
	@Nullable
	public SchoolLifeData getSchoolLifeData() throws EcoleDirecteAccountTypeException, EcoleDirecteUnknownConnectionException, EcoleDirecteIOException {
		if(!account.getTypeCompte().equals("E"))
			throw new EcoleDirecteAccountTypeException(1);
		try {
			String r = HttpUtils.sendRequest(ECOLEDIRECTE_STUDENTS_SECTION_URL + id + "/viescolaire.awp?verbe=get", ECOLEDIRECTE_JSON_DATA_START_TOKEN + token + "\"}", "POST", true, true);
			SchoolLifeJson schoolLifeJson = new Gson().fromJson(r, SchoolLifeJson.class);
			if(schoolLifeJson.getCode() != 200) {
				throw new EcoleDirecteUnknownConnectionException();
			}
			return schoolLifeJson.getData();
		} catch (IOException e) {
			e.printStackTrace();
			throw new EcoleDirecteIOException();
		}
	}
}
