package ceylon.interop.spring;

import org.eclipse.ceylon.common.NonNull;
import org.eclipse.ceylon.common.Nullable;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameter;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameters;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.NoRepositoryBean;

import java.io.Serializable;
import java.util.List;

/**
 * A {@link JpaRepository} which supports use of Ceylon's
 * {@link ceylon.language.Integer} or
 * {@link ceylon.language.String} as an identifier type,
 * in place of Java's {@link java.lang.Long} or
 * {@link java.lang.String}.
 *
 * @param <Entity> the entity type
 * @param <Id> the identifier type
 */
@NoRepositoryBean
@TypeParameters({@TypeParameter(value = "Entity",
                                satisfies = "ceylon.language::Object"),
                 @TypeParameter(value = "Id",
                                satisfies = "ceylon.language::Object")})
public interface CeylonRepository<Entity, Id extends Serializable>
        extends JpaRepository<Entity, Id> {

    //FROM CrudRepository
    
    @Override @NonNull
    <ConcreteEntity extends Entity> ConcreteEntity save(@NonNull ConcreteEntity entity);

    @Override @NonNull
    <ConcreteEntity extends Entity> List<ConcreteEntity> save(@NonNull Iterable<ConcreteEntity> entities);

    @Override @Nullable
    Entity findOne(@NonNull Id id);

    @Override
    boolean exists(@NonNull Id id);

    @Override @NonNull
    List<Entity> findAll();

    @Override @NonNull
    List<Entity> findAll(@NonNull Iterable<Id> ids);

    @Override
    long count();

    @Override
    void delete(@NonNull Id id);

    @Override
    void delete(@NonNull Entity entity);

    @Override
    void delete(@NonNull Iterable<? extends Entity> entities);

    @Override
    void deleteAll();

    //FROM JpaRepository

    @Override @NonNull
    List<Entity> findAll(@NonNull Sort sort);

    @Override
    void flush();

    @Override @NonNull
    <ConcreteEntity extends Entity> ConcreteEntity saveAndFlush(@NonNull ConcreteEntity entity);

    @Override
    void deleteInBatch(@NonNull Iterable<Entity> entities);

    @Override
    void deleteAllInBatch();

    @Override @NonNull
    Entity getOne(@NonNull Id id);

    @Override @NonNull
    <ConcreteEntity extends Entity> List<ConcreteEntity> findAll(@NonNull Example<ConcreteEntity> example);

    @Override @NonNull
    <ConcreteEntity extends Entity> List<ConcreteEntity> findAll(@NonNull Example<ConcreteEntity> example, @NonNull Sort sort);

    @Override @NonNull
    Page<Entity> findAll(@NonNull Pageable pageable);

    @Override @Nullable
    <ConcreteEntity extends Entity> ConcreteEntity findOne(@NonNull Example<ConcreteEntity> example);

    @Override @NonNull
    <ConcreteEntity extends Entity> Page<ConcreteEntity> findAll(@NonNull Example<ConcreteEntity> example, @NonNull Pageable pageable);

    @Override
    <ConcreteEntity extends Entity> long count(@NonNull Example<ConcreteEntity> example);

    @Override
    <ConcreteEntity extends Entity> boolean exists(@NonNull Example<ConcreteEntity> example);
}
