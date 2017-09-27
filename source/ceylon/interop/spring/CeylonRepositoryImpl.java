package ceylon.interop.spring;

import ceylon.language.Integer;
import ceylon.language.String;
import org.eclipse.ceylon.common.NonNull;
import org.eclipse.ceylon.common.Nullable;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameter;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameters;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * JPA-based implementation of {@link CeylonRepository}.
 *
 * Performs type conversion on identifiers of type
 * {@link ceylon.language.Integer} and
 * {@link ceylon.language.String}.
 *
 * @param <Entity> the entity type
 * @param <Id> the identifier type
 */
@Transactional(readOnly = true)
@TypeParameters({@TypeParameter(value = "Entity",
                                satisfies = "ceylon.language::Object"),
                 @TypeParameter(value = "Id",
                                satisfies = "ceylon.language::Object")})
@SuppressWarnings("unchecked")
public class CeylonRepositoryImpl<Entity, Id extends Serializable>
        extends SimpleJpaRepository<Entity, Id>
        implements CeylonRepository<Entity, Id> {

    public CeylonRepositoryImpl(JpaEntityInformation entityInformation,
                                EntityManager entityManager) {
        super(entityInformation, entityManager);
    }

    @Override @Ignore @Transactional
    public void delete(@NonNull Id id) {
        super.delete(toJavaId(id));
    }

    @Override @Ignore
    public boolean exists(@NonNull Id id) {
        return super.exists(toJavaId(id));
    }

    @Override @Ignore @NonNull
    public Entity getOne(@NonNull Id id) {
        return super.getOne(toJavaId(id));
    }

    @Override @Ignore @Nullable
    public Entity findOne(@NonNull Id id) {
        return super.findOne(toJavaId(id));
    }

    @Override @Ignore @NonNull
    public List<Entity> findAll(@NonNull Iterable<Id> ids) {
        List<Id> javaIds = new ArrayList<Id>();
        for (Id id: ids) {
            javaIds.add(toJavaId(id));
        }
        return super.findAll(javaIds);
    }

    @NonNull private Id toJavaId(@NonNull Id id) {
        Object javaId;
        if (id instanceof Integer) {
            javaId = ((Integer) id).longValue();
        }
        else if (id instanceof String) {
            javaId = id.toString();
        }
        else {
            javaId = id;
        }
        return (Id) javaId;
    }
}
