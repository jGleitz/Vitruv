package edu.kit.ipd.sdq.vitruvius.dsls.mapping.tests.generated;

import static edu.kit.ipd.sdq.vitruvius.dsls.mapping.testframework.util.MappingLanguageTestUtil.createAttributeTUIDMetamodel;
import static edu.kit.ipd.sdq.vitruvius.dsls.mapping.testframework.util.MappingLanguageTestUtil.createEmptyMetaRepository;
import static org.eclipse.xtext.xbase.lib.IterableExtensions.head;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.junit.Test;
import org.junit.runner.Description;

import edu.kit.ipd.sdq.vitruvius.dsls.mapping.tests.generated.testinfrastructure.TestPCM2UMLBaseChange2CommandTransformingProviding;
import edu.kit.ipd.sdq.vitruvius.dsls.response.tests.AbstractResponseTests;
import edu.kit.ipd.sdq.vitruvius.framework.metarepository.MetaRepositoryImpl;
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.Pair;
import edu.kit.ipd.sdq.vitruvius.tests.TestUserInteractor;
import pcm_mockup.Repository;
import uml_mockup.UPackage;
import uml_mockup.Uml_mockupFactory;

public class TestMockupUMLPCMBase extends AbstractResponseTests {
	private final static String MODEL_PATH_PREFIX = "model/";

	private final static Logger LOGGER = Logger.getLogger(TestMockupUMLPCMBase.class);

	public TestMockupUMLPCMBase() {
		super(TestPCM2UMLBaseChange2CommandTransformingProviding::new);
	}

	@Override
	protected void initializeTestModel() {
		// do nothing
	}

	protected Collection<Pair<String, String>> getMetamodelURIsAndExtensions() {
		Set<Pair<String, String>> result = new HashSet<>();
		result.add(new Pair<>("http://edu.kit.ipd.sdq.vitruvius.tests.metamodels.pcm_mockup", "mpcm"));
		result.add(new Pair<>("http://edu.kit.ipd.sdq.vitruvius.tests.metamodels.uml_mockup", "muml"));

		return result;
	}

	@Override
	protected MetaRepositoryImpl createMetaRepository() {
		return createEmptyMetaRepository(getMetamodelURIsAndExtensions().stream()
				.map(it -> createAttributeTUIDMetamodel(it.getFirst(), it.getSecond())).collect(Collectors.toList()));
	}

	private UPackage createAndSyncPackage(String name, String fileName) {
		UPackage upkg = Uml_mockupFactory.eINSTANCE.createUPackage();
		upkg.setName(name);
		createAndSychronizeModel(MODEL_PATH_PREFIX + fileName, upkg);

		return upkg;
	}

	private static <T> List<T> asList(T in) {
		List<T> result = new ArrayList<>();
		result.add(in);
		return result;
	}

	private TestUserInteractor testUserInteractor;

	@Override
	public void beforeTest(Description description) throws Throwable {
		super.beforeTest(description);
		System.out.println("Test setupTestUserInteractor()");

		this.testUserInteractor = new TestUserInteractor();
		setUserInteractor(testUserInteractor);
	}

	private URI getLocalModelURI(String modelFileName) {
		return getModelVURI(MODEL_PATH_PREFIX + modelFileName).getEMFUri();
	}

	@Test
	public void createPackageAndSync() throws Throwable {
		System.out.println("Test createPackageAndSync()");

		testUserInteractor.addNextSelections(getLocalModelURI("repo.mpcm"));
		UPackage upkg = createAndSyncPackage("TestPackage", "pkg.muml");
		assertTrue(testUserInteractor.isResourceQueueEmpty());

		Set<List<EObject>> correspondingEObjects = getCorrespondenceInstance().getCorrespondingEObjects(asList(upkg));

		assertEquals("#[new package] must correspond with exactly one object list", 1, correspondingEObjects.size());
		assertEquals("corresponding object list must have size one", 1, head(correspondingEObjects).size());
		assertTrue("corresponding object must be a repository",
				head(head(correspondingEObjects)) instanceof Repository);
	}

	@Test
	public void createPackageAndSyncWithName() throws Throwable {
		System.out.println("Test createPackageAndSyncWithName()");

		testUserInteractor.addNextSelections(getLocalModelURI("repo.mpcm"));
		UPackage upkg = createAndSyncPackage("TestPackage", "pkg.muml");
		assertTrue(testUserInteractor.isResourceQueueEmpty());

		Set<List<EObject>> correspondingEObjects = getCorrespondenceInstance().getCorrespondingEObjects(asList(upkg));

		assertEquals("#[new package] must correspond with exactly one object", 1, correspondingEObjects.size());
		assertEquals("corresponding object list must have size one", 1, head(correspondingEObjects).size());
		assertTrue("corresponding object must be a repository",
				head(head(correspondingEObjects)) instanceof Repository);
		Repository repository = (Repository) (head(head(correspondingEObjects)));

		assertEquals("the package and the repository must have the same name", upkg.getName(), repository.getName());
	}
}