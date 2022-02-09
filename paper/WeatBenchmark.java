import java.util.Arrays;
// import java.util.Scanner;

/*
 * @author Aylin Caliskan (aylinc@princeton.edu)
 * Simplfied by Chung-hong Chan
 */

public class WeatBenchmark {
	public static void main(String[] args) throws Exception{
	    // Create a symlink
    	String semanticModel="glove.840B.300d.txt";
    	int wordDimension =300;
    	String delimiter =" ";	//dimension delimiter in the word embeddings
    	boolean caseSensitive=true; //prefer case sensitivity
    	boolean checkWordPresence=true;
    	int iterations = 1000000;
    	String distribution = "normal";
    	    	
    	String[] target1 = {"math" , "algebra" , "geometry" , "calculus" , "equations" , "computation" , "numbers" , "addition"};
    	String[] target2 = {"poetry" , "art" , "sculpture" , "dance" , "literature" , "novel" , "symphony" , "drama"};
    	String[] attribute1 = {"brother" , "male" , "man" , "boy" , "son" , "he" , "his" , "him"};
    	String[] attribute2 = {"sister" , "female" , "woman" , "girl" , "daughter" , "she" , "hers" , "her"};
	if(checkWordPresence == true){
	    //remove words from categories if they do not exist
	    target1 = Utils.removeCategoryWordsIfNotInDictionary(target1, semanticModel, wordDimension, delimiter, caseSensitive);
	    target2 = Utils.removeCategoryWordsIfNotInDictionary(target2, semanticModel, wordDimension, delimiter, caseSensitive);
	    attribute1 = Utils.removeCategoryWordsIfNotInDictionary(attribute1, semanticModel, wordDimension, delimiter, caseSensitive);
	    attribute2 = Utils.removeCategoryWordsIfNotInDictionary(attribute2, semanticModel, wordDimension, delimiter, caseSensitive);
	}
	double ts = Utils.getTestStatistic(target1, target2, attribute1, attribute2,  caseSensitive,  semanticModel,  wordDimension,  delimiter);
	// Actually this function don't need iterations; but I don't want to modify Utils.java
	double [] entireDistribution = Utils.getEntireDistribution(target1, target2, attribute1, attribute2,  caseSensitive,  semanticModel,  wordDimension,  delimiter, iterations); 
	double es = Utils.effectSize(entireDistribution, ts);
	System.out.println("effectSize: "+ es );
    	}
}
